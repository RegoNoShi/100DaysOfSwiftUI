//
//  Song+CoreDataProperties.swift
//  CoreDataIntroduction
//
//  Created by Massimo Omodei on 14.12.20.
//
//

import Foundation
import CoreData


extension Song {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Song> {
        return NSFetchRequest<Song>(entityName: "Song")
    }

    @NSManaged public var title: String?
    @NSManaged public var sungBy: Singer?

    var wrappedTitle: String {
        title ?? "No title"
    }
}

extension Song : Identifiable {

}
