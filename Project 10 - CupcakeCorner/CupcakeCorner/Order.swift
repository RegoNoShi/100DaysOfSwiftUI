//
//  Order.swift
//  CupcakeCorner
//
//  Created by Massimo Omodei on 05.12.20.
//

import Foundation

struct Order: Codable {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]

    private enum CodingKeys: CodingKey {
        case type, quantity, extraFrosting, addSprinkles, name, streetAddress, city, zip
    }

    var type = 0
    var quantity = 3

    var specialRequestEnabled = false {
        didSet {
            if !specialRequestEnabled {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false

    var cost: Double {
        var cost: Double = 2
        cost += Double(type) / 2
        cost += extraFrosting ? 1 : 0
        cost += addSprinkles ? 0.5 : 0
        return cost * Double(quantity)
    }

    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""

    var hasValidAddress: Bool {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            streetAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            zip.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return false
        }

        return true
    }
}
