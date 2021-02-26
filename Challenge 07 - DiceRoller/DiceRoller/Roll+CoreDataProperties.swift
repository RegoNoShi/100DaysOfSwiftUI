//
//  Roll+CoreDataProperties.swift
//  DiceRoller
//
//  Created by Massimo Omodei on 25.02.21.
//
//

import CoreData

extension Roll {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Roll> {
        return NSFetchRequest<Roll>(entityName: "Roll")
    }
    
    @nonobjc public class func fetchAllByTimestampDesc() -> NSFetchRequest<Roll> {
        let request = NSFetchRequest<Roll>(entityName: "\(Self.self)")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Roll.timestamp, ascending: false)]
        return request
    }

    @NSManaged public var id: Int64
    @NSManaged public var timestamp: Date?
    @NSManaged public var numberOfFaces: Int64
    @NSManaged public var dice: String?
    
    var wrappedTimestamp: Date {
        timestamp ?? Date()
    }

    var wrappedDice: [Int] {
        dice?.components(separatedBy: ",").compactMap { Int($0) } ?? []
    }
    
    var total: Int {
        wrappedDice.reduce(0) { $0 + $1 }
    }
}

extension Roll : Identifiable {}
