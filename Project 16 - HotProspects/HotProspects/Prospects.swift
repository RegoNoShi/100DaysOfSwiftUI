//
//  Prospect.swift
//  HotProspects
//
//  Created by Massimo Omodei on 18.02.21.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    let id: UUID
    let name: String
    let emailAddress: String
    let added: Date
    fileprivate(set) var isContacted = false
    
    init(name: String, emailAddress: String, id: UUID = UUID(), added: Date = Date()) {
        self.name = name
        self.emailAddress = emailAddress
        self.id = id
        self.added = added
    }
}

class Prospects: ObservableObject {
    enum SortType: String, Codable {
        case addedAscending, addedDescending, nameAscending, nameDescending
        
        var sortBy: (Prospect, Prospect) -> Bool {
            switch self {
            case .addedAscending: return { p1, p2 in p1.added < p2.added }
            case .addedDescending: return { p1, p2 in p1.added > p2.added }
            case .nameAscending: return { p1, p2 in p1.name < p2.name }
            case .nameDescending: return { p1, p2 in p1.name > p2.name }
            }
        }
    }
    
    private static let peopleKey = "SavedPeople"
    private static let sortTypeKey = "SortType"
    private let peopleUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("\(peopleKey).json")
    
    
    @Published private(set) var sortType = SortType.addedDescending
    @Published private(set) var people = [Prospect]()

    init() {
        loadPeople()
        loadSortType()
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        savePeople()
    }
    
    func remove(_ prospectId: UUID) {
        if let prospectIndex = people.firstIndex(where: { $0.id == prospectId }) {
            people.remove(at: prospectIndex)
            savePeople()
        }
    }
    
    func toggle(_ prospectId: UUID) {
        if let prospect = people.first(where: { $0.id == prospectId }) {
            objectWillChange.send()
            prospect.isContacted.toggle()
            savePeople()
        }
    }
    
    func setSortType(_ sortType: SortType) {
        self.sortType = sortType
        saveSortType()
    }
    
    private func savePeople() {
        if let data = try? JSONEncoder().encode(people) {
            try? data.write(to: peopleUrl)
        }
    }
    
    private func loadPeople() {
        if let data = try? Data(contentsOf: peopleUrl),
           let savedPeople = try? JSONDecoder().decode([Prospect].self, from: data) {
            people = savedPeople
        }
    }
    
    private func loadSortType() {
        if let savedSortType = UserDefaults.standard.string(forKey: Prospects.sortTypeKey) {
            sortType = SortType(rawValue: savedSortType) ?? .addedDescending
        }
    }
    
    private func saveSortType() {
        UserDefaults.standard.setValue(sortType.rawValue, forKey: Prospects.sortTypeKey)
    }
}
