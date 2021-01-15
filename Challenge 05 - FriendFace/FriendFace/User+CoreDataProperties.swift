//
//  User+CoreDataProperties.swift
//  FriendFace
//
//  Created by Massimo Omodei on 15.01.21.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var isActive: Bool
    @NSManaged public var age: Int16
    @NSManaged public var company: String?
    @NSManaged public var email: String?
    @NSManaged public var address: String?
    @NSManaged public var about: String?
    @NSManaged public var registered: Date?
    @NSManaged public var tags: String?
    @NSManaged public var friends: NSSet?

    var wrappedId: String {
        id ?? ""
    }

    var wrappedName: String {
        name ?? ""
    }

    var wrappedCompany: String {
        company ?? ""
    }

    var wrappedEmail: String {
        email ?? ""
    }

    var wrappedAddress: String {
        address ?? ""
    }

    var wrappedAbout: String {
        about ?? ""
    }

    var wrappedTags: String {
        tags ?? ""
    }

    var wrappedRegistered: Date {
        registered ?? Date()
    }

    var wrappedFriends: [Friend] {
        let set = friends as? Set<Friend> ?? []
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
}

// MARK: Generated accessors for friends
extension User {

    @objc(addFriendsObject:)
    @NSManaged public func addToFriends(_ value: Friend)

    @objc(removeFriendsObject:)
    @NSManaged public func removeFromFriends(_ value: Friend)

    @objc(addFriends:)
    @NSManaged public func addToFriends(_ values: NSSet)

    @objc(removeFriends:)
    @NSManaged public func removeFromFriends(_ values: NSSet)

}

extension User : Identifiable {

}
