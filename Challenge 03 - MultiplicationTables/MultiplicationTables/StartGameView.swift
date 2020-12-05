//
//  StartGameView.swift
//  Multiplication Tables
//
//  Created by Massimo Omodei on 05.12.20.
//

import SwiftUI

struct StartGameView: View {
    private let minTable = 2
    private let maxTable = 100
    private let questionOptions = [QuestionOption.number(5), .number(10), .number(25), .number(50), .all]
    private let responseTimes = [2, 3, 5, 10, 30]

    @State private var selectedTable = 3
    @State private var selectedQuestionOption = 0
    @State private var selectedResponseTime = 0

    var onStartGame: (Int, QuestionOption, Int) -> Void

    var body: some View {
        Group {
            Form {
                Section(header: Text("Game Options")) {
                    Stepper("Table size: \(selectedTable)", value: $selectedTable, in: minTable...maxTable)
                    Picker("Number of questions", selection: $selectedQuestionOption) {
                        ForEach(0 ..< questionOptions.count) { index -> Text in
                            switch(questionOptions[index]) {
                            case .all:
                                return Text("All")
                            case .number(let questionNumber):
                                return Text("\(questionNumber)")
                            }

                        }
                    }
                    Picker("Response time", selection: $selectedResponseTime) {
                        ForEach(0 ..< responseTimes.count) {
                           Text("\(responseTimes[$0])s")
                        }
                    }
                    Button("Start") {
                        onStartGame(selectedTable,
                                    questionOptions[selectedQuestionOption],
                                    responseTimes[selectedResponseTime])
                        print(responseTimes[selectedResponseTime])
                    }
                }
            }
        }
    }
}

struct StartGameView_Previews: PreviewProvider {
    static var previews: some View {
        StartGameView { _, _, _ in }
    }
}
