//
//  Expenses.swift
//  iExpense
//
//  Created by Massimo Omodei on 06.12.20.
//

import Foundation

struct ExpenseItem: Codable, Identifiable, Equatable {
    var id = UUID()
    var name: String
    var amount: Double
    var type: String
    var date = Date()
}

class Expenses: ObservableObject {
    private static let key = "expenses"
    @Published var items: [ExpenseItem] {
        didSet {
            guard let data = try? JSONEncoder().encode(items) else {
                fatalError("Unable to encode expenses")
            }
            UserDefaults.standard.set(data, forKey: Expenses.key)
        }
    }

    init() {
        guard let data = UserDefaults.standard.data(forKey: Expenses.key),
              let expenses = try? JSONDecoder().decode([ExpenseItem].self, from: data) else {
            items = []
            return
        }

        items = expenses
    }
}
