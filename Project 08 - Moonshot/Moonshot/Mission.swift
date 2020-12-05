//
//  Mission.swift
//  Moonshotv
//
//  Created by Massimo Omodei on 10.11.20.
//

import Foundation

struct Mission: Codable, Identifiable {
    struct CrewRole: Codable {
        let name: String
        let role: String
    }

    let id: Int
    let crew: [CrewRole]
    let description: String
    let launchDate: Date?

    var image: String {
        "apollo\(id)"
    }

    var displayName: String {
        "Apollo \(id)"
    }

    var formattedLaunchDate: String {
        if let launchDate = launchDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: launchDate)
        } else {
            return "N/A"
        }
    }
}
