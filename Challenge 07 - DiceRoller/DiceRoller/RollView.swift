//
//  RollView.swift
//  DiceRoller
//
//  Created by Massimo Omodei on 24.02.21.
//

import SwiftUI

struct RollView: View {
    @EnvironmentObject private var model: DiceRollerModel
    @State private var isShowingSettings = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    if let roll = model.rolls.first {
                        GridView(items: roll.dice) { dice in
                            DiceView(dice: dice, rollId: roll.id, maxValue: model.numberOfFaces, animated: true)
                                .padding(4)
                        }
                        .padding()

                        HStack {
                            Text("Total: \(roll.total)")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.white)
                                .animation(.none)
                        }
                        .padding(.horizontal)
                    } else {
                        Spacer()
                        
                        (
                            Text("No dice rolled yet...\n\nTap ")
                             + Text("Roll")
                                .italic()
                                .bold()
                            + Text(" to throw the dice!")
                        )
                        .font(.title)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        
                        Spacer()
                    }
                    
                    HStack {
                        Button(action: {
                            model.update(numberOfDice: model.numberOfDice - 1)
                        }) {
                            Image(systemName: "minus.circle")
                                .bigButton(color: .red)
                        }
                        .disabled(model.numberOfDice == 1)
                        
                        Spacer()
                        
                        Button("Roll") {
                            withAnimation {
                                model.roll()
                            }
                        }
                        .padding(.horizontal)
                        .bigButton(color: .blue)
                        
                        Spacer()
                        
                        Button(action: {
                            model.update(numberOfDice: model.numberOfDice + 1)
                        }) {
                            Image(systemName: "plus.circle")
                                .bigButton(color: .green)
                        }
                    }
                    .padding(.horizontal)
                    
                    Text("Dice: \(model.numberOfDice), Faces: \(model.numberOfFaces)")
                        .foregroundColor(.white)
                        .font(.callout)
                        .padding(.bottom)
                }
            }
            .navigationTitle("Dice Roller")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingSettings = true
                    }) {
                        Image(systemName: "gear")
                    }
                }
            }
            .sheet(isPresented: $isShowingSettings) {
                SettingsView()
            }
        }
        .onAppear {
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            UINavigationBar.appearance().tintColor = .white
        }
    }
}

private struct BigButton: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
            .background(color)
            .clipShape(Capsule())
            .shadow(radius: 10)
    }
}

private extension View {
    func bigButton(color: Color = .blue) -> some View {
        modifier(BigButton(color: color))
    }
}

struct RollView_Previews: PreviewProvider {
    static var previews: some View {
        RollView()
    }
}
