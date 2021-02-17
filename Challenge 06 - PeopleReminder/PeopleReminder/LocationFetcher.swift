//
//  LocationFetcher.swift
//  PeopleReminder
//
//  Created by Massimo Omodei on 16.02.21.
//

import CoreLocation
import SwiftUI

class LocationFetcher: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let manager = CLLocationManager()
    
    @Published private(set) var lastKnownLocation: CLLocation?
    
    override init() {
        super.init()
        manager.delegate = self
    }

    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func stop() {
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first
    }
}
