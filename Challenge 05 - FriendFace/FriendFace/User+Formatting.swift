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
        dateFormatter.string(from: wrappedRegistered)
    }

    var displayableActiveState: String {
        isActive ? "🟢 Active" : "🔴 Offline"
    }

    var displayableShortActiveState: String {
        isActive ? "🟢" : "🔴"
    }
}
