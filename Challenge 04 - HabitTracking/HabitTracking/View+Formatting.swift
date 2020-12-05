//
//  View+Formatting.swift
//  HabitTracking
//
//  Created by Massimo Omodei on 25.11.20.
//

import Foundation

extension Double {
    var asFormattedDuration: String {
        let hours = Int(floor(self))
        let minutes = Int((self - floor(self)) * 60)
        if hours == 1 && minutes > 0 {
            return "\(hours) hour \(minutes) minutes"
        } else if hours >= 1 && minutes > 0 {
            return "\(hours) hours \(minutes) minutes"
        } else if hours == 1 {
            return "\(hours) hour"
        } else if hours > 1 {
            return "\(hours) hours"
        } else {
            return "\(minutes) minutes"
        }
    }
}

extension HabitProgress {
    private var dateTimeFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter
    }


    var displayableDetails: String {
        var details = "On \(dateTimeFormatter.string(from: date))"
        if let displayableDuration = duration?.asFormattedDuration {
            details.append(" for \(displayableDuration)")
        }
        return details
    }
}
