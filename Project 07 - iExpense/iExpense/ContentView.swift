//
//  ContentView.swift
//  iExpense
//
//  Created by Massimo Omodei on 05.12.20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var expenses = Expenses()
    @State private var showingAddExpense = false
    @State private var editMode: EditMode = .inactive

    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.locale = Locale.current
        return df
    }()

    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { expense in
                    VStack {
                        HStack {
                            Text(expense.name)
                                .font(.headline)

                            Spacer()

                            Text("€ \(expense.amount, specifier: "%.2f")")
                                .font(.headline)
                        }

                        HStack {
                            Text(expense.type)
                                .font(.subheadline)

                            Spacer()

                            Text(dateFormatter.string(for: expense.date) ?? "")
                                .font(.subheadline)
                        }
                    }
                    .foregroundColor(expense.amount < 10 ? Color.green : expense.amount < 100 ? Color.orange : Color.red)
                }
                .onDelete(perform: removeExpenses)
            }
            .navigationTitle("iExpense")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        showingAddExpense.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                    .disabled(editMode.isEditing)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                        .disabled(expenses.items.isEmpty)
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddExpenseView(expenses: expenses)
            }
            .environment(\.editMode, $editMode)
            .onChange(of: expenses.items, perform: { value in
                if value.isEmpty {
                    $editMode.wrappedValue = .inactive
                }
            })
        }
    }

    private func removeExpenses(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
