//
//  MapView.swift
//  PeopleReminder
//
//  Created by Massimo Omodei on 17.02.21.
//

import SwiftUI
import UIKit
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var location: CLLocation?
    
    func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView()
        view.delegate = context.coordinator
        return view
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        showLocation(uiView)
    }
    
    private func showLocation(_ uiView: MKMapView) {
        if let location = location, location.coordinate != uiView.annotations.first?.coordinate {
            lookUpCurrentLocation(location: location) { placemark in
                uiView.setCenter(location.coordinate, animated: true)
                uiView.setCameraZoomRange(MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 2000), animated: true)
                let annotation = MKPointAnnotation()
                annotation.title = "Current location"
                annotation.subtitle = placemark?.formattedDescription
                annotation.coordinate = location.coordinate
                uiView.removeAnnotations(uiView.annotations)
                uiView.addAnnotation(annotation)
                uiView.selectAnnotation(annotation, animated: true)
            }
        }
    }
    
    private func lookUpCurrentLocation(location: CLLocation, completionHandler: @escaping (CLPlacemark?) -> Void ) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if error == nil {
                completionHandler(placemarks?[0])
            } else {
                completionHandler(nil)
            }
        }
    }
    
    internal class Coordinator: NSObject, MKMapViewDelegate {
        private let view: MapView

        init(_ mapView: MapView) {
            view = mapView
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            view.canShowCallout = true
            return view
        }
        
        func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
            view.showLocation(mapView)
        }
    }
}

private extension CLPlacemark {
    var formattedDescription: String {
        [name, locality, country, postalCode].compactMap { $0 }.joined(separator: ", ")
    }
}

extension CLLocationCoordinate2D: Equatable {
    static public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
