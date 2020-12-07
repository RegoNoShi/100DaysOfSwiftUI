//
//  AddExpenseView.swift
//  iExpense
//
//  Created by Massimo Omodei on 07.12.20.
//

import SwiftUI

struct AddExpenseView: View {
    private static let types = ["Personal", "Business"]

    @Environment(\.presentationMode) private var presentationMode

    @ObservedObject var expenses: Expenses

    @State private var name = ""
    @State private var type = AddExpenseView.types[0]
    @State private var amount = ""
    @State private var validateAmount = false
    @State private var validateName = false

    private var isNameInvalid: Bool {
        name.count == 0
    }

    private var isAmountInvalid: Bool {
        Double(amount) == nil
    }

    private var isExpenseInvalid: Bool {
        isNameInvalid || Double(amount) == nil
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Expense data")) {
                    ZStack(alignment: .trailing) {
                        TextField("Name", text: $name)
                            .onChange(of: name, perform: { _ in
                                validateName = true
                                print("validateName")
                            })

                        if (validateName && isNameInvalid) {
                            Image(systemName: "xmark.octagon.fill")
                                .foregroundColor(.red)

                        }
                    }

                    Picker("Type", selection: $type) {
                        ForEach(AddExpenseView.types, id: \.self) {
                            Text($0)
                        }
                    }

                    ZStack(alignment: .trailing) {
                        TextField("Name", text: $amount)
                            .keyboardType(.decimalPad)
                            .onChange(of: amount, perform: { _ in
                                validateAmount = true
                            })

                        if (validateAmount && isAmountInvalid) {
                            Image(systemName: "xmark.octagon.fill")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Add new expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Save") {
                        if let actualAmount = Double(amount) {
                            let item = ExpenseItem(name: name, amount: actualAmount, type: type)
                            expenses.items.append(item)
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            validateName = true
                            validateAmount = true
                        }
                    }
                }
            }
        }
    }
}

struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseView(expenses: Expenses())
    }
}
