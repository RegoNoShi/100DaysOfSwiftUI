//
//  ContentView.swift
//  Flashzilla
//
//  Created by Massimo Omodei on 19.02.21.
//

import SwiftUI
import CoreHaptics

private extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        offset(CGSize(width: 0, height: CGFloat(total - position) * 10))
    }
}

private enum SheetType {
    case settings, editCards, none
}

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) private var differentiateWithoutColor
    @Environment(\.accessibilityEnabled) private var accessibilityEnabled
    @State private var cards = [Card]()
    @State private var timeRemaining = 100
    @State private var isActive = true
    @State private var sheetType = SheetType.none
    @State private var correctAnswers = 0
    @State private var totalQuestions = 0
    @State private var engine: CHHapticEngine?
    @State private var reproposeWrongCards = UserDefaults.standard.bool(forKey: "ReproposeWrongCards")
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        let showingSheet = Binding {
            sheetType != .none
        } set: {
            sheetType = $0 ? sheetType : .none
        }
        
        return ZStack {
            Image(decorative: "background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(Color.black.opacity(0.75)))
                
                if timeRemaining > 0 {
                    ZStack {
                        ForEach(cards.indices, id: \.self) { index in
                            CardView(card: cards[index]) { correct in
                                totalQuestions += 1
                                if correct {
                                    correctAnswers += 1
                                }
                                withAnimation {
                                    if !correct && reproposeWrongCards {
                                        cards.insert(cards.remove(at: index), at: 0)
                                    } else {
                                        removeCard(at: index)
                                    }
                                }
                            }
                            .allowsHitTesting(index == cards.count - 1)
                            .accessibility(hidden: index < cards.count - 1)
                            .stacked(at: index, in: cards.count)
                        }
                    }
                    .allowsHitTesting(timeRemaining > 0)
                }
                
                if cards.isEmpty || timeRemaining == 0 {
                    Text("Correct answers: \(correctAnswers)/\(totalQuestions)")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .background(Capsule().fill(Color.black.opacity(0.75)))
                    
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                        .padding()
                }
            }
            
            VStack {
                HStack {
                    Button(action: {
                        sheetType = .settings
                    }) {
                        Image(systemName: "gear")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                    
                    Spacer()

                    Button(action: {
                        sheetType = .editCards
                    }) {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }

                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
            if differentiateWithoutColor || accessibilityEnabled {
                VStack {
                    Spacer()

                    HStack {
                        Button(action: {
                            withAnimation {
                                removeCard(at: cards.count - 1)
                            }
                        }) {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Wrong"))
                        .accessibility(hint: Text("Mark your answer as being incorrect."))
                        
                        Spacer()

                        Button(action: {
                            withAnimation {
                                removeCard(at: cards.count - 1)
                            }
                        }) {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Correct"))
                        .accessibility(hint: Text("Mark your answer as being correct."))
                    }
                }
            }
        }
        .onAppear(perform: resetCards)
        .sheet(isPresented: showingSheet, onDismiss: resetCards) {
            sheetContent
        }
        .onReceive(timer) { _ in
            guard isActive else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                gameOver()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
            isActive = false
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            isActive = !cards.isEmpty
        }
    }
    
    private var sheetContent: some View {
        return Group {
            switch sheetType {
            case .settings:
                SettingsView()
            case .editCards:
                EditCardsView()
            case .none:
                Group {}
            }
        }
    }
    
    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decodedCards = try? JSONDecoder().decode([Card].self, from: data) {
                cards = decodedCards
                cards.shuffle()
            }
        }
    }
    
    private func resetCards() {
        reproposeWrongCards = UserDefaults.standard.bool(forKey: "ReproposeWrongCards")
        prepareHaptics()
        timeRemaining = 100
        isActive = true
        loadData()
        totalQuestions = 0
        correctAnswers = 0
    }
    
    private func removeCard(at index: Int) {
        guard index >= 0 else { return }
        cards.remove(at: index)
        if cards.isEmpty {
            isActive = false
            gameOver()
        }
    }
    
    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    private func gameOver() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        var events = [CHHapticEvent]()

        for i in stride(from: Float(1.0), to: 3, by: 1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: i * 0.33)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: i * 0.33)
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: Double(i) * 0.2)
            events.append(event)
        }

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
