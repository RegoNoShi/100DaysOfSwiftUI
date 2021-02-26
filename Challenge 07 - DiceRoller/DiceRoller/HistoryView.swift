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
                        ForEach(model.rolls, id: \.id) { roll in
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.green)
                                
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Dice: \(roll.wrappedDice.count)")
                                            .multilineTextAlignment(.center)
                                        
                                        Spacer()
                                        
                                        Text("Faces: \(roll.numberOfFaces)")
                                            .multilineTextAlignment(.center)
                                        
                                        Spacer()
                                        
                                        Text("Total: \(roll.total)")
                                            .multilineTextAlignment(.center)
                                    }
                                    
                                    GridView(items: roll.wrappedDice) { dice in
                                        DiceView(dice: dice, rollId: Int(roll.id), maxValue: Int(roll.numberOfFaces))
                                            .padding(2)
                                    }
                                    .frame(height: 75 + CGFloat(roll.wrappedDice.count / 5) * 75)
                                    .padding(-2)
                                    .padding(.vertical)
                                    
                                    HStack {
                                        Image(systemName: "calendar")
                                        
                                        Text(customDateFormatter.string(from: roll.wrappedTimestamp))
                                        
                                        Spacer()
                                        
                                        Image(systemName: "number")
                                        
                                        Text("\(roll.id)")
                                    }
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
