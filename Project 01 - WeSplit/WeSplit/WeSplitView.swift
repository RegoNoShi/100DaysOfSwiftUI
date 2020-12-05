//
//  WeSplitView.swift
//  WeSplit
//
//  Created by Massimo Omodei on 16.11.20.
//

import SwiftUI

struct WeSplitView: View {
    @State private var checkAmount = ""
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 2
    @State private var previousAmount = ""

    private let tipPercentages = [10, 15, 20, 25, 0]

    private var isValidAmount: Bool {
        checkAmount.isEmpty || amountWithTip > 0
    }

    private var amountWithTip: Double {
        let tipSelection = Double(tipPercentages[tipPercentage])
        let orderAmount = Double(checkAmount) ?? 0
        let tipValue = orderAmount / 100 * tipSelection
        return orderAmount + tipValue
    }

    private var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        return amountWithTip / peopleCount
    }

    private func onCheckAmountChanged(_ newAmount: String) {
        if !newAmount.isEmpty, Double(newAmount) == nil {
            checkAmount = previousAmount
        } else {
            previousAmount = newAmount
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack(alignment: .trailing) {
                        HStack(alignment: .center) {
                            Text("€")

                            ZStack(alignment: .trailing) {
                                TextField("Check amount", text: $checkAmount)
                                    .keyboardType(.decimalPad)
                                    .onChange(of: checkAmount, perform: onCheckAmountChanged)

                                if !isValidAmount {
                                    Image(systemName: "xmark.octagon.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }

                        if !isValidAmount {
                            Text("Please enter a valid amount")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }

                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2 ..< 100) {
                            Text("\($0) people")
                        }
                    }
                }

                Section(header: Text("How much tip do you want to leave?")) {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0 ..< tipPercentages.count) {
                            Text("\(self.tipPercentages[$0])%")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section {
                    HStack(alignment: .center) {
                        Text("Amount per person")

                        Spacer()

                        Text("€ \(totalPerPerson, specifier: "%.2f")")
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Capsule())
                    }

                    HStack(alignment: .center) {
                        Text("Check amount with tip")

                        Spacer()

                        Text("€ \(amountWithTip, specifier: "%.2f")")
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Capsule())
                    }
                }
            }
            .navigationTitle("WeSplit")
        }
    }
}

struct WeSplitView_Previews: PreviewProvider {
    static var previews: some View {
        WeSplitView()
    }
}
