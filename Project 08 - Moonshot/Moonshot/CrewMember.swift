//
//  CrewMember.swift
//  Moonshot
//
//  Created by Massimo Omodei on 11.11.20.
//

import Foundation

struct CrewMember: Identifiable {
    let role: String
    let astronaut: Astronaut

    var id: String {
        astronaut.id
    }
}
