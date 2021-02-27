//
//  ResortsListView.swift
//  SnowSeeker
//
//  Created by Massimo Omodei on 26.02.21.
//

import SwiftUI

struct ResortsListView: View {
    @EnvironmentObject private var favorites: Favorites
    @EnvironmentObject private var filters: Filters
    @State private var isShowingSort = false
    @State private var isShowingFilters = false
    @State private var sortType = Resort.sortByName
    
    var filteredResorts: [Resort] {
        var resorts = Resort.allResorts
        
        let sizes = filters.sizeFilters.filter { $0.enabled }
        if !sizes.isEmpty {
            resorts = resorts.filter { resort in sizes.contains { $0.id == resort.size }}
        }
        
        let prices = filters.priceFilters.filter { $0.enabled }
        if !prices.isEmpty {
            resorts = resorts.filter { resort in prices.contains { $0.id == resort.price }}
        }
        
        let countries = filters.countriesFilters.filter { $0.enabled }
        if !countries.isEmpty {
            resorts = resorts.filter { resort in countries.contains { $0.name == resort.country }}
        }
        
        return resorts
    }
    
    var body: some View {
        List(filteredResorts.sorted(by: sortType)) { resort in
            NavigationLink(destination: ResortView(resort: resort)) {
                HStack {
                    Image(resort.country)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 25)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 1))

                    VStack(alignment: .leading) {
                        Text(resort.name)
                            .font(.headline)
                            
                        Text("\(resort.runs) runs")
                            .foregroundColor(.secondary)
                    }
                    
                    if favorites.contains(resort) {
                        Spacer(minLength: 0)
                        
                        Image(systemName: "heart.fill")
                            .accessibility(label: Text("This is a favorite resort"))
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .actionSheet(isPresented: $isShowingSort) {
            ActionSheet(title: Text("How do you want to sort the resorts?"), message: nil,
                        buttons: [
                            .default(Text("By name")) { sortType = Resort.sortByName },
                            .default(Text("By country")) { sortType = Resort.sortByCountry },
                            .cancel()
                        ])
        }
        .sheet(isPresented: $isShowingFilters) {
            FiltersView()
        }
        .navigationTitle("Resorts")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isShowingFilters = true
                }) {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isShowingSort = true
                }) {
                    Image(systemName: "arrow.up.arrow.down.circle")
                }
            }
        }
    }
}

private extension Resort {
    static func sortByName(lhs: Resort, rhs: Resort) -> Bool {
        lhs.name < rhs.name
    }
    
    static func sortByCountry(lhs: Resort, rhs: Resort) -> Bool {
        lhs.country < rhs.country
    }
}

struct ResortsListView_Previews: PreviewProvider {
    static var previews: some View {
        ResortsListView()
    }
}
