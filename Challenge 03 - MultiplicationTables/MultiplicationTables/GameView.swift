//
//  GameView.swift
//  Multiplication Tables
//
//  Created by Massimo Omodei on 05.12.20.
//

import SwiftUI

struct GameView: View {
    @State private var answer = ""
    @State private var currentQuestion = 0
    @State private var correctAnswers = 0
    @State private var resultShown = false
    @State private var message = " "
    @State private var timeLeft = 0
    @State private var inputDisabled = false

    var responseTime: Int
    var onGameOver: (Int, Int) -> Void
    private var questions = [Question]()

    @State private var timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()

    init(selectedTable: Int, questionOption: QuestionOption, responseTime: Int,
         onGameOver: @escaping (Int, Int) -> Void) {
        self.responseTime = responseTime
        self.onGameOver = onGameOver

        switch questionOption {
        case .all:
            for operand1 in 2 ... selectedTable {
                for operand2 in 2 ... selectedTable {
                    questions.append(Question(operands: (operand1, operand2), result: operand1 * operand2))
                }
            }
        case .number(let questionNumber):
            for _ in 0 ..< questionNumber {
                let operand1 = Int.random(in: 1 ... selectedTable)
                let operand2 = Int.random(in: 1 ... selectedTable)
                questions.append(Question(operands: (operand1, operand2), result: operand1 * operand2))
            }
        }
        questions.shuffle()
    }

    var body: some View {
        VStack {
            Text("Time left: \(timeLeft)s")
                .padding(.top)
                .onReceive(timer) { _ in
                    timeLeft -= 1
                    if timeLeft <= 0 {
                        timer.upstream.connect().cancel()
                        inputDisabled = true
                        message = "Time's up :("
                        resultShown = true
                    }
                }
                .onAppear {
                    timeLeft = responseTime
                }

            Spacer()

            Text("\(questions[currentQuestion].operands.0) X \(questions[currentQuestion].operands.1)\n=")
                .font(.largeTitle)
                .multilineTextAlignment(.center)

            Spacer()

            TextField("Enter the result", text: $answer)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .disabled(inputDisabled)

            Spacer()

            Text(message)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .padding()

            Button(resultShown ? "Continue" : "Confirm") {
                if resultShown {
                    continueToNextQuestion()
                } else {
                    checkResult()
                }
            }

            Spacer()
        }
    }

    private func continueToNextQuestion() {
        answer = ""
        message = " "
        timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
        timeLeft = responseTime
        resultShown.toggle()

        if currentQuestion + 1 == questions.count {
            onGameOver(correctAnswers, questions.count)
        } else {
            currentQuestion += 1
        }
    }

    private func checkResult() {
        guard let result = Int(answer) else {
            message = "Enter a valid number"
            answer = ""
            return
        }

        resultShown.toggle()
        if result == questions[currentQuestion].result {
            message = "Correct answer!!!"
            correctAnswers += 1
        } else {
            message = "Incorrect... \(questions[currentQuestion].operands.0) X \(questions[currentQuestion].operands.1) = \(questions[currentQuestion].result)"
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(selectedTable: 4, questionOption: .all, responseTime: 5,
                 onGameOver: { _, _ in })
    }
}
