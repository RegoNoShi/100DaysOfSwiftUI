//
//  Friend+CoreDataProperties.swift
//  FriendFace
//
//  Created by Massimo Omodei on 15.01.21.
//
//

import Foundation
import CoreData


extension Friend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Friend> {
        return NSFetchRequest<Friend>(entityName: "Friend")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var friendOf: User?

    var wrappedId: String {
        id ?? ""
    }

    var wrappedName: String {
        name ?? ""
    }

}

extension Friend : Identifiable {

}
