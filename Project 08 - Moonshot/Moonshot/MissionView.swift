//
//  MissionView.swift
//  Moonshot
//
//  Created by Massimo Omodei on 11.11.20.
//

import SwiftUI

private struct ResizeWhileScrolling: ViewModifier {
    var padding: CGFloat
    var maxPadding: CGFloat
    
    private var actualPadding: CGFloat {
        min(maxPadding, padding)
    }
    
    func body(content: Content) -> some View {
        content
            .padding(.top, actualPadding)
            .padding(.horizontal, actualPadding / 2)
    }
}

private extension View {
    func resizeWhileScrolling(padding: CGFloat = 0, maxPadding: CGFloat = 50) -> some View {
        modifier(ResizeWhileScrolling(padding: padding, maxPadding: maxPadding))
    }
}

struct MissionView: View {
    private static let paddingTop: CGFloat = 10
    let mission: Mission
    
    @State private var offset = CGFloat.zero

    var body: some View {
        VStack {
            GeometryReader { fullView in
                ScrollView(.vertical) {
                    GeometryReader { geo in
                        Image(mission.image)
                            .resizable()
                            .scaledToFit()
                            .resizeWhileScrolling(padding: -(geo.frame(in: .named("ScrollViewCS")).minY - MissionView.paddingTop),
                                                  maxPadding: min(fullView.size.width, fullView.size.height) / 2)
                    }
                    .frame(width: fullView.size.width * 0.7, height: fullView.size.width * 0.7)
                    .padding(.top, MissionView.paddingTop)
                    
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

                        Spacer()
                    }
                }
                .coordinateSpace(name: "ScrollViewCS")
            }
        }
        .navigationTitle(mission.displayName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MissionView_Previews: PreviewProvider {
    static var previews: some View {
        MissionView(mission: missions[6])
    }
}
