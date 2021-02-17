//
//  PeopleReminderModel.swift
//  PeopleReminder
//
//  Created by Massimo Omodei on 16.02.21.
//

import SwiftUI
import CoreLocation

class PeopleReminderModel: ObservableObject {
    private let peopleJsonUrl: URL
    
    @Published private(set) var people = [Person]() {
        didSet {
            savePeople()
        }
    }
    
    private let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    init(jsonFileName: String = "people") {
        print(documentDirectory)
        let imagesUrl = documentDirectory.appendingPathComponent("images")
        if !FileManager.default.fileExists(atPath: imagesUrl.absoluteString) {
            try? FileManager.default.createDirectory(at: imagesUrl, withIntermediateDirectories: true)
        }
        peopleJsonUrl = documentDirectory.appendingPathComponent("\(jsonFileName).json")
        loadPeople()
    }
    
    func savePerson(_ person: Person) {
        if let personIndex = people.firstIndex(of: person) {
            people.remove(at: personIndex)
        }
        people.append(person)
    }
    
    func delete(at offsets: IndexSet) {
        people.remove(atOffsets: offsets)
    }
        
    private func loadPeople() {
        guard let data = try? Data(contentsOf: peopleJsonUrl),
              let savedPeople = try? JSONDecoder().decode([Person].self, from: data) else {
            return
        }
        
        people = savedPeople
        
        print(people)
    }
    
    private func savePeople() {
        guard let data = try? JSONEncoder().encode(people) else {
            return
        }
        
        do {
            try data.write(to: peopleJsonUrl)
        } catch {
            print("Error saving people to json: \(error)")
        }
    }
}

struct Person: Codable, Comparable, Equatable, Identifiable {
    var name: String
    var id: String
    var lastModified: Date = Date()
    var email: String?
    var phoneNumber: String?
    var notes: String?
    var coordinate: CLLocationCoordinate2D?
    
    var location: CLLocation? {
        if let coordinate = coordinate {
            return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
        return nil
    }
    
    init(name: String, email: String? = nil, phoneNumber: String? = nil, notes: String? = nil,
         coordinate: CLLocationCoordinate2D? = nil, id: String? = nil) {
        self.id = id ?? UUID().uuidString
        self.name = name
        self.email = nilIfEmpty(string: email)
        self.phoneNumber = nilIfEmpty(string: phoneNumber)
        self.notes = nilIfEmpty(string: notes)
        self.coordinate = coordinate
    }
    
    static func == (lhs: Person, rhs: Person) -> Bool {
        lhs.id == rhs.id
    }
    
    static func < (lhs: Person, rhs: Person) -> Bool {
        lhs.name < rhs.name
    }
    
    private func nilIfEmpty(string: String?) -> String? {
        (string?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) ? nil : string
    }
}

extension CLLocationCoordinate2D: Codable {
    private enum CodingKeys: CodingKey {
        case latitude, longitude
    }
    
    public init(from decoder: Decoder) throws {
        self.init()

        let container = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
}
