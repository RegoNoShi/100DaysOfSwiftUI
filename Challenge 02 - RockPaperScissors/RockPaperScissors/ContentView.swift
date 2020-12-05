//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Massimo Omodei on 20.10.20.
//

import SwiftUI

enum Choice: String, CaseIterable, Identifiable {
    case Rock = "Rock"
    case Paper = "Paper"
    case Scissors = "Scissors"

    var id: String { rawValue }

    var iconName: String {
        switch self {
        case .Paper:
            return "doc.fill"
        case .Rock:
            return "capsule.fill"
        case .Scissors:
            return "scissors"
        }
    }

    func winAgainst(_ choice: Choice) -> Bool {
        switch choice {
        case .Paper:
            return self == .Scissors
        case .Rock:
            return self == .Paper
        case .Scissors:
            return self == .Rock
        }
    }
}

struct ContentView: View {
    @State private var appChoice = Choice.allCases.randomElement()!
    @State private var shouldPlayerWin = Bool.random()
    @State private var score = 0
    @State private var lastResult = ""
    @State private var round = 1
    @State private var showFinalResult = false

    var body: some View {
        VStack {
            Text("Welcome to Rock Paper Scissors!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(.blue)
                .padding()

            Text("Round \(round): Make the correct choices to \(shouldPlayerWin ? "win" : "lose") the game")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.blue)
                .padding()

            VStack {
                ForEach(Choice.allCases) { choice in
                    Button(action: {
                        handleChoice(choice)
                    }) {
                        HStack(spacing: 20) {
                            Image(systemName: choice.iconName)
                            Text(choice.rawValue)

                        }
                    }
                    .padding()
                    .background(Color.purple.opacity(0.3))
                    .clipShape(Capsule())
                    .padding()
                }
            }

            Spacer()

            Text(lastResult)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.blue)
                .padding()

            Spacer()

            Text("Score: \(score)")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.blue)
                .padding()

            Spacer()
        }
        .alert(isPresented: $showFinalResult) {
            Alert(title: Text("Game Over"), message: Text("Your final score is \(score)"), dismissButton: .cancel(Text("Start New Game")) {
                round = 1
                shouldPlayerWin = Bool.random()
                appChoice = Choice.allCases.randomElement()!
                lastResult = ""
                score = 0
            })
        }
    }

    private func isCorrectAnswer(_ choice: Choice) -> Bool {
        if (shouldPlayerWin) {
            return choice.winAgainst(appChoice)
        } else {
            return appChoice.winAgainst(choice)
        }
    }

    private func handleChoice(_ choice: Choice) {
        if (isCorrectAnswer(choice)) {
            score += 1
            lastResult = "Correct! You \(shouldPlayerWin ? "won" : "loose") with \(choice.rawValue) against \(appChoice.rawValue)"

        } else {
            score -= 1
            lastResult = "Bad luck! You \(!shouldPlayerWin ? "won" : "loose") with \(choice.rawValue) against \(appChoice.rawValue)"
        }

        round += 1
        shouldPlayerWin = Bool.random()
        appChoice = Choice.allCases.randomElement()!

        if(round == 11) {
            showFinalResult = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
