//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Massimo Omodei on 26.02.21.
//

import SwiftUI

class Favorites: ObservableObject {
    private var resorts: Set<String> = []

    private let saveKey = "Favorites"

    init() {
        load()
    }

    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }

    func add(_ resort: Resort) {
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }

    func remove(_ resort: Resort) {
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }

    func save() {
        guard let data = try? JSONEncoder().encode(resorts) else { return }
        
        UserDefaults.standard.setValue(data, forKey: saveKey)
    }
    
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: saveKey),
              let savedResorts = try? JSONDecoder().decode(Set<String>.self, from: data) else { return }

        resorts = savedResorts
    }
}
