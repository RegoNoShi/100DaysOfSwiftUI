//
//  Filters.swift
//  SnowSeeker
//
//  Created by Massimo Omodei on 26.02.21.
//

import Foundation

struct Filter {
    var name: String
    var enabled: Bool
    var id: Int?
}

class Filters: ObservableObject {
    @Published var priceFilters = [
        Filter(name: "Small", enabled: false, id: 1),
        Filter(name: "Average", enabled: false, id: 2),
        Filter(name: "Large", enabled: false, id: 3)
    ]
    
    @Published var sizeFilters = [
        Filter(name: "$", enabled: false, id: 1),
        Filter(name: "$$", enabled: false, id: 2),
        Filter(name: "$$$", enabled: false, id: 3)
    ]
    
    @Published var countriesFilters = Set(Resort.allResorts.map { $0.country }).map { country in
        Filter(name: country, enabled: false)
    }
    
    func resetAll() {
        for index in priceFilters.indices { priceFilters[index].enabled = false }
        for index in sizeFilters.indices { sizeFilters[index].enabled = false }
        for index in countriesFilters.indices { countriesFilters[index].enabled = false }
    }
}
