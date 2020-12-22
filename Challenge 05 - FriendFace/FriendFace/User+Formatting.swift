//
//  User+Formatting.swift
//  FriendFace
//
//  Created by Massimo Omodei on 17.12.20.
//

import Foundation

private let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateStyle = .medium
    return df
}()

extension User {
    var displayableAge: String {
        "\(age)yo"
    }

    var displayableRegistrationDate: String {
        dateFormatter.string(from: registered)
    }

    var displayableActiveState: String {
        isActive ? "🟢 Active" : "🔴 Offline"
    }

    var displayableShortActiveState: String {
        isActive ? "🟢" : "🔴"
    }

    var displayableTags: String {
        tags.map { "#\($0)" }.joined(separator: ", ")
    }
}
