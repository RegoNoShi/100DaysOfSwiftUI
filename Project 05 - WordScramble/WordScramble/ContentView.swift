//
//  ContentView.swift
//  WordScramble
//
//  Created by Massimo Omodei on 01.11.20.
//

import SwiftUI

struct ContentView: View {
    private static let scoreMappings = [3: 3, 4: 5, 5: 7, 6: 10, 7: 14, 8: 20]
    @State private var usedWords = [String]()
    @State private var newWord = ""
    @State private var rootWord = ""
    @State private var alert: Alert?
    @State private var showAlert = false
    @State private var score = 0
    @State private var time = 10
    
    private func drift(for geo: GeometryProxy) -> CGFloat {
        max(geo.frame(in: .global).minY - 900 + geo.size.width, 0)
    }
    
    private func color(for position: CGFloat, in size: CGFloat) -> Color {
        Color(hue: 1.5 - Double(position / size), saturation: 1, brightness: 1)
    }

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()
                
                GeometryReader { fullList in
                    List(usedWords.indices, id: \.self) { index in
                        GeometryReader { geo in
                            HStack {
                                Image(systemName: "\(usedWords[index].count).circle")
                                    .foregroundColor(color(for: geo.frame(in: .global).minY,
                                                           in: fullList.frame(in: .global).height))
                                
                                Text(usedWords[index])
                            }
                            .offset(x: drift(for: geo))
                            .accessibilityElement(children: .ignore)
                            .accessibility(label: Text("\(usedWords[index]), \(usedWords[index].count) letters"))
                        }
                    }
                }
                
                HStack {
                    Text("Score: \(score)")
                        .font(.title)

                    Spacer()

//                    Text("Time: \(time)")
//                        .font(.title)
                }
                .padding()
            }
            .navigationBarTitle(rootWord)
            .navigationBarItems(trailing:
                Button("Start New Game") {
                    startNewGame()
                }
            )
            .onAppear(perform: startNewGame)
            .alert(isPresented: $showAlert) {
                guard let alert = alert else {
                    fatalError("The alert is undefined")
                }
                return alert
            }
        }
    }

    private func startNewGame() {
        guard let wordFileUrl = Bundle.main.url(forResource: "start", withExtension: "txt"),
              let words = try? String(contentsOf: wordFileUrl).components(separatedBy: "\n"),
              let word = words.randomElement()?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            fatalError("Could not load start.txt from bundle.")
        }

        rootWord = word
        newWord = ""
        usedWords.removeAll()
        usedWords = Array(0...100).map { "Row \($0)" }
        score = 0
        time = 60

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if time > 0 {
                time -= 1
            } else {
                timer.invalidate()
                showScore()
            }
        }
    }

    private func addNewWord() {
        let word = newWord.lowercased().trimmingCharacters(in: CharacterSet.letters.inverted)

        guard word != rootWord else {
            showError("You cannot just use the original word!")
            return
        }

        guard word.count >= 3 else {
            showError("Please enter a word composed by at least 3 characters (only letters)")
            return
        }

        guard word.isValid else {
            showError("Please enter a valid word")
            return
        }

        guard isNew(word) else {
            showError("Please enter a word not already in the list")
            return
        }

        guard isPossible(word) else {
            showError("Please enter a word made by the letter in the original word")
            return
        }

        score += ContentView.scoreMappings[word.count] ?? 0
        usedWords.insert(word, at: 0)
        newWord = ""
    }

    private func showError(_ message: String) {
        alert = Alert(title: Text("Invalid word"), message: Text(message), dismissButton: .cancel(Text("OK")))
        showAlert = true
    }

    private func showScore() {
        alert = Alert(title: Text("Game Over"), message: Text("Your final score is \(score)!!!"), dismissButton: .cancel(Text("Start New Game")) {
            startNewGame()
        })
        showAlert = true
    }

    private func isNew(_ word: String) -> Bool {
        !usedWords.contains(word)
    }

    private func isPossible(_ word: String) -> Bool {
        var letters = rootWord

        for letter in word {
            if let index = letters.firstIndex(of: letter) {
                letters.remove(at: index)
            } else {
                return false
            }
        }
        return true
    }
}

private extension String {
    var isValid: Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: utf16.count)
        let errorRange = checker.rangeOfMisspelledWord(in: self, range: range, startingAt: 0, wrap: false, language: "en")
        return errorRange.location == NSNotFound
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
