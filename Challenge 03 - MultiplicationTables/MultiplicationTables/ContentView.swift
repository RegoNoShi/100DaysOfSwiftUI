//
//  ContentView.swift
//  Multiplication Tables
//
//  Created by Massimo Omodei on 07.11.20.
//

import SwiftUI

struct ContentView: View {
    @State private var gameStarted = false
    @State private var alertShown = false
    @State private var message = ""
    @State private var selectedTable = 3
    @State private var questionOption = QuestionOption.all
    @State private var responseTime = 5

    var body: some View {
        NavigationView {
            Group {
                if gameStarted {
                    GameView(selectedTable: selectedTable, questionOption: questionOption, responseTime: responseTime, onGameOver: { correctAnswers, questions in
                        gameStarted = false
                        message = "You scored \(correctAnswers)/\(questions) correct answers"
                        alertShown = true
                    })
                    .navigationBarTitleDisplayMode(.inline)
                } else {
                    StartGameView { selectedTable, questionOption, responseTime in
                        self.selectedTable = selectedTable
                        self.questionOption = questionOption
                        self.responseTime = responseTime
                        print(responseTime)

                        gameStarted = true
                    }
                    .navigationBarTitleDisplayMode(.automatic)
                }
            }
            .navigationTitle("Multiplication Trainer")
            .alert(isPresented: $alertShown) {
                Alert(title: Text("Game Over!"), message: Text(message),
                      dismissButton: .default(Text("Close")))
            }
        }
    }
}

enum QuestionOption {
    case all
    case number(Int)
}

struct Question {
    let operands: (Int, Int)
    let result: Int
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
