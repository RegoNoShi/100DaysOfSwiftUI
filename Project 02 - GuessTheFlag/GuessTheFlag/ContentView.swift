//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Paul Hudson on 17/02/2020.
//  Copyright © 2020 Paul Hudson. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    @State private var lastResult = "Correct"
    @State private var lastAnswer: Int?

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .padding()
                        .foregroundColor(.white)

                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .animation(.easeInOut)
                }

                Spacer()

                ForEach(0 ..< 3) { number in
                    Button(action: {
                        guard lastAnswer == nil else { return }
                        lastAnswer = number
                        flagTapped(number)
                    }) {
                        Image(countries[number])
                            .renderingMode(.original)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                            .shadow(color: .black, radius: 2)
                            .scaleEffect(lastAnswer != nil && number == correctAnswer ? 1.3 : 1)
                            .animation(.default)
                            .opacity(lastAnswer != nil && number != correctAnswer ? 0.25 : 1)
                            .rotation3DEffect(.degrees(lastAnswer == number && correctAnswer == lastAnswer ? 360 : 0),
                                              axis: (x: 0.0, y: 1.0, z: 0.0))
                            .scaleEffect(lastAnswer != nil && number == correctAnswer ? 1.1 : 1)
                            .modifier(Shake(animatableData: CGFloat(lastAnswer == number &&
                                                                        lastAnswer != correctAnswer ? 1 : 0)))
                            .animation(lastAnswer != nil ? .default : .none)
                    }
                }

                Spacer()

                Text("\(lastResult)")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .opacity(lastAnswer != nil ? 1 : 0)
                    .animation(.easeInOut)

                Text("Your score is: \(score)")
                    .foregroundColor(.white)
                    .font(.title3)

                Spacer()
            }
        }
    }

    private func flagTapped(_ number: Int) {
        if number == correctAnswer {
            lastResult = "Correct"
            score += 5
        } else {
            lastResult = "Wrong"
            score -= 10
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.linear) {
                askQuestion()
            }
        }
    }

    private func askQuestion() {
        lastAnswer = nil
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)), y: 0))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
