//
//  MoonshotViewModel.swift
//  Moonshot
//
//  Created by Massimo Omodei on 11.11.20.
//

import Foundation

let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
let missions: [Mission] = Bundle.main.decode("missions.json")

extension Astronaut {
    var carriedOutMissions: [Mission] {
        missions.filter { mission in
            mission.crew.contains { member in
                member.name == id
            }
        }
    }
}

extension Mission {
    var crewMembers: [CrewMember] {
        crew.map { member in
            guard let astronaut = astronauts.first(where: { $0.id == member.name }) else {
                fatalError("Found missing astronaut \(member.name)")
            }

            return CrewMember(role: member.role, astronaut: astronaut)
        }
    }
}
