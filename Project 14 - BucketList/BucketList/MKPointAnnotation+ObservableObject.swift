//
//  MKPointAnnotation.swift
//  BucketList
//
//  Created by Massimo Omodei on 01.02.21.
//

import MapKit

extension MKPointAnnotation: ObservableObject {
    var wrappedTitle: String {
        get {
            title ?? "Unknown"
        }

        set {
            title = newValue
        }
    }

    var wrappedSubtitle: String {
        get {
            subtitle ?? "Unknown"
        }

        set {
            subtitle = newValue
        }
    }
}
