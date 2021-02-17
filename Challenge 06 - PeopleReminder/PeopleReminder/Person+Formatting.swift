//
//  Person+Formatting.swift
//  PeopleReminder
//
//  Created by Massimo Omodei on 16.02.21.
//

import Foundation

private let formatAsDate: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()

extension Person {
    var formattedLastModified: String {
        formatAsDate.string(from: lastModified)
    }
}
