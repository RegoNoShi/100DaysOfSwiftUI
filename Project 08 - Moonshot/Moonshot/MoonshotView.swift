//
//  ContentView.swift
//  Moonshotv
//
//  Created by Massimo Omodei on 10.11.20.
//

import SwiftUI

struct MoonshotView: View {
    @State private var showLaunchDate = true

    var body: some View {
        NavigationView {
            List(missions) { mission in
                NavigationLink(destination: MissionView(mission: mission)) {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)

                    VStack(alignment: .leading) {
                        Text(mission.displayName)
                            .font(.headline)
                        
                        Text(showLaunchDate ? "Launch date: \(mission.formattedLaunchDate)" : mission.displayableCrewMembers)
                            .font(.subheadline)
                    }
                }
            }
            .navigationTitle("Moonshot")
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button(showLaunchDate ? "Show crew" : "Show launch date") {
                        showLaunchDate.toggle()
                    }
                }
            }
        }
    }
}

private extension Mission {
    var displayableCrewMembers: String {
        crewMembers.map { $0.astronaut.name }.joined(separator: "\n")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MoonshotView()
    }
}
