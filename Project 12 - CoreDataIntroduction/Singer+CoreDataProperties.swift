//
//  Singer+CoreDataProperties.swift
//  CoreDataIntroduction
//
//  Created by Massimo Omodei on 14.12.20.
//
//

import Foundation
import CoreData


extension Singer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Singer> {
        return NSFetchRequest<Singer>(entityName: "Singer")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var sings: NSSet?

    var wrappedFirstName: String {
        firstName ?? "Unknown"
    }

    var wrappedLastName: String {
        lastName ?? "Unknown"
    }

    var singsArray: [Song] {
        let set = sings as? Set<Song> ?? []
        return set.sorted {
            $0.wrappedTitle < $1.wrappedTitle
        }
    }
}

// MARK: Generated accessors for sings
extension Singer {

    @objc(addSingsObject:)
    @NSManaged public func addToSings(_ value: Song)

    @objc(removeSingsObject:)
    @NSManaged public func removeFromSings(_ value: Song)

    @objc(addSings:)
    @NSManaged public func addToSings(_ values: NSSet)

    @objc(removeSings:)
    @NSManaged public func removeFromSings(_ values: NSSet)

}

extension Singer : Identifiable {

}
