//
//  AstronautView.swift
//  Moonshot
//
//  Created by Massimo Omodei on 11.11.20.
//

import SwiftUI

struct AstronautView: View {
    let astronaut: Astronaut

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                Image(astronaut.id)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width)

                Text(astronaut.description)
                    .padding()
                    .layoutPriority(1)

                VStack(alignment: .leading) {
                    Text("Carried   out missions:")
                        .font(.title)
                        .padding()

                    ForEach(astronaut.carriedOutMissions) { mission in
                        NavigationLink(destination: MissionView(mission: mission)) {
                            HStack {
                                Image(mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 44, height: 44)

                                VStack(alignment: .leading) {
                                    Text(mission.displayName)
                                        .font(.headline)

                                    Text("Launch date: \(mission.formattedLaunchDate)")
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
            .navigationTitle(astronaut.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


struct AstronautView_Previews: PreviewProvider {
    static var previews: some View {
        AstronautView(astronaut: astronauts[14])
    }
}
