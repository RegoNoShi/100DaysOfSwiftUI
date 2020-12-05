//
//  MissionView.swift
//  Moonshot
//
//  Created by Massimo Omodei on 11.11.20.
//

import SwiftUI

struct MissionView: View {
    let mission: Mission

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                Image(mission.image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: geometry.size.width * 0.7)
                    .padding(.top)

                Text("Launch date: \(mission.formattedLaunchDate)")
                    .padding()

                Text(mission.description)
                    .padding()
                    .layoutPriority(1)

                VStack(alignment: .leading) {
                    Text("Crew members:")
                        .font(.title)
                        .padding()

                    ForEach(mission.crewMembers) { member in
                        NavigationLink(destination: AstronautView(astronaut: member.astronaut)) {
                            HStack {
                                Image(member.astronaut.id)
                                    .resizable()
                                    .frame(width: 83, height: 60)
                                    .clipShape(Capsule())
                                    .overlay(Capsule().stroke(Color.primary, lineWidth: 1))

                                VStack(alignment: .leading) {
                                    Text(member.astronaut.name)
                                        .font(.headline)

                                    Text(member.role)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.leading)

                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }

                Spacer()
            }
            .navigationTitle(mission.displayName)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct MissionView_Previews: PreviewProvider {
    static var previews: some View {
        MissionView(mission: missions[6])
    }
}
