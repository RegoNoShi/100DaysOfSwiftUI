//
//  FilteredList.swift
//  CoreDataIntroduction
//
//  Created by Massimo Omodei on 14.12.20.
//

import SwiftUI
import CoreData

enum Filter {
    case BeginsWith(key: String, value: String)
    case EndsWith(key: String, value: String)
    case Contains(key: String, value: String)

    var asPredicate: NSPredicate {
        switch self {
        case .BeginsWith(let key, let value):
            return NSPredicate(format: "%K BEGINSWITH %@", key, value)
        case .EndsWith(let key, let value):
            return NSPredicate(format: "%K ENDSWITH %@", key, value)
        case .Contains(let key, let value):
            return NSPredicate(format: "%K CONTAINS %@", key, value)
        }
    }
}

struct FilteredList<T: NSManagedObject, Content: View>: View {
    private var fetchRequest: FetchRequest<T>
    private let content: (T) -> Content

    init(filter: Filter?, sortDescriptors: [NSSortDescriptor] = [],
         @ViewBuilder content: @escaping (T) -> Content) {
        fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: sortDescriptors,
                                       predicate: filter?.asPredicate)
        self.content = content
    }

    var body: some View {
        List {
            ForEach(fetchRequest.wrappedValue, id: \.self, content: content)
        }
    }
}

struct FilteredList_Previews: PreviewProvider {
    static var previews: some View {
        FilteredList(filter: .Contains(key: "lastName", value: "A")) { (singer: Singer) in
            Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
        }
    }
}
