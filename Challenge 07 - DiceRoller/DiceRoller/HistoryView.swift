//
//  HistoryView.swift
//  DiceRoller
//
//  Created by Massimo Omodei on 25.02.21.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject private var model: DiceRollerModel
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                if model.rolls.isEmpty {
                    Text("No dice rolled yet...")
                        .font(.title)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    List {
                        ForEach(model.rolls, id: \.number) { roll in
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.green)
                                
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Dice: \(roll.dice.count)")
                                        
                                        Spacer()
                                        
                                        Text("Total: \(roll.total)")
                                    }
                                    
                                    GridView(items: roll.dice) { dice in
                                        DiceView(dice: dice)
                                            .padding(2)
                                    }
                                    .frame(height: 75 + CGFloat(roll.dice.count / 5) * 75)
                                    .padding(-2)
                                    
                                    HStack {
                                        Image(systemName: "calendar")
                                        
                                        Text(customDateFormatter.string(from: roll.time))
                                        
                                        Spacer()
                                        
                                        Image(systemName: "number")
                                        
                                        Text("\(roll.number)")
                                    }
                                    .padding(.top)
                                }
                                .foregroundColor(.white)
                                .padding()
                            }
                            .shadow(radius: 3)
                        }
                        .listRowBackground(Color.clear)
                    }
                    .onAppear {
                        UITableView.appearance().backgroundColor = .clear
                        UITableViewCell.appearance().backgroundColor = .clear
                    }
                }
            }
            .navigationTitle("History")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        model.clearHistory()
                    }) {
                        Image(systemName: "trash")
                    }
                }
            }
        }
    }
}

private let customDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .short
    return dateFormatter
}()

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
