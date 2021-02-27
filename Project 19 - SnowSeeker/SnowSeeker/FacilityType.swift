//
//  Facility.swift
//  SnowSeeker
//
//  Created by Massimo Omodei on 26.02.21.
//

import SwiftUI

enum FacilityType: String, Identifiable {
    case accomodation = "Accomodation"
    case beginners = "Beginners"
    case crossCountry = "Cross-country"
    case ecoFriendly = "Eco-friendly"
    case family = "Family"
    
    var id: String {
        rawValue
    }
    
    var icon: some View {
        Image(systemName: iconName)
            .accessibility(label: Text(rawValue))
            .foregroundColor(.secondary)
    }
    
    var alert: Alert {
        Alert(title: Text(rawValue), message: Text(message))
    }
    
    private var iconName: String {
        switch self {
        case .accomodation:
            return "house"
        case .family:
            return "person.3"
        case .beginners:
            return "1.circle"
        case .crossCountry:
            return "map"
        case .ecoFriendly:
            return "leaf.arrow.circlepath"
        }
    }
    
    private var message: String {
        switch self {
        case .accomodation:
            return "This resort has popular on-site accommodation."
        case .family:
            return "This resort is popular with families."
        case .beginners:
            return "This resort has lots of ski schools."
        case .crossCountry:
            return "This resort has many cross-country ski routes."
        case .ecoFriendly:
            return "This resort has won an award for environmental friendliness."
        }
    }
}

extension Resort {
    var facilityTypes: [FacilityType] {
        facilities.compactMap(FacilityType.init)
    }
}
