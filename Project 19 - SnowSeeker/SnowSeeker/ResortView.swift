//
//  ResortView.swift
//  SnowSeeker
//
//  Created by Massimo Omodei on 26.02.21.
//

import SwiftUI

struct ResortView: View {
    @Environment(\.horizontalSizeClass) private var sizeClass
    @State private var selectedFacility: FacilityType?
    @EnvironmentObject private var favorites: Favorites
    
    let resort: Resort
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Image(decorative: resort.id)
                    .resizable()
                    .scaledToFit()
                    .watermarked(with: resort.imageCredit)

                Group {
                    HStack {
                        if sizeClass == .compact {
                            Spacer()
                            
                            VStack { ResortDetailsView(resort: resort) }
                            
                            Spacer()
                            
                            VStack { SkiDetailsView(resort: resort) }
                            
                            Spacer()
                        } else {
                            ResortDetailsView(resort: resort)
                            
                            Spacer()
                                .frame(height: 0)
                            
                            SkiDetailsView(resort: resort)
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.top)
                    
                    Text(resort.description)
                        .padding(.vertical)

                    Text("Facilities")
                        .font(.headline)

                    HStack {
                        ForEach(resort.facilityTypes) { facility in
                            facility.icon
                                .font(.title)
                                .onTapGesture {
                                    selectedFacility = facility
                                }
                        }
                    }
                    .padding(.vertical)
                }
                .padding(.horizontal)
            }
            
            Button(favorites.contains(resort) ? "Remove from Favorites" : "Add to Favorites") {
                if favorites.contains(resort) {
                    favorites.remove(resort)
                } else {
                    favorites.add(resort)
                }
            }
            .padding()
        }
        .navigationTitle("\(resort.name), \(resort.country)")
        .navigationBarTitleDisplayMode(.inline)
        .alert(item: $selectedFacility) { facility in
            facility.alert
        }
    }
}

extension String: Identifiable {
    public var id: String { self }
}

struct ResortView_Previews: PreviewProvider {
    static var previews: some View {
        ResortView(resort: Resort.allResorts[0])
    }
}
