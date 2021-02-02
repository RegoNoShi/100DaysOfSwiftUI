//
//  MapView.swift
//  BucketList
//
//  Created by Massimo Omodei on 01.02.21.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    let annotations: [MKPointAnnotation]
    let onInfoTapped: (MKPointAnnotation) -> Void
    let onDeleteTapped: (MKPointAnnotation) -> Void
    let onLongPress: (CLLocationCoordinate2D) -> Void
    private let mapView = MKMapView()

    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        if annotations.count != uiView.annotations.count {
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotations(annotations)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
        private let parent: MapView
        private static let deleteTag = 547382

        init(parent: MapView) {
            self.parent = parent
            super.init()

            let lpgr = UILongPressGestureRecognizer(target: self, action:#selector(handleLongPress(gestureRecognizer:)))
            lpgr.minimumPressDuration = 1
            lpgr.delaysTouchesBegan = true
            lpgr.delegate = self
            parent.mapView.addGestureRecognizer(lpgr)
        }

        @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
            guard gestureRecognizer.state == UIGestureRecognizer.State.began else {
                return
            }

            let touchMapCoordinate = parent.mapView.convert(gestureRecognizer.location(in: parent.mapView),
                                                            toCoordinateFrom: parent.mapView)
            parent.onLongPress(touchMapCoordinate)
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "Placemark"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                let deleteButton = UIButton(type: .detailDisclosure)
                deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
                deleteButton.tag = Coordinator.deleteTag
                annotationView?.leftCalloutAccessoryView = deleteButton
            } else {
                annotationView?.annotation = annotation
            }

            return annotationView
        }

        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                     calloutAccessoryControlTapped control: UIControl) {
            guard let placemark = view.annotation as? MKPointAnnotation else { return }

            if control.tag == Coordinator.deleteTag {
                parent.onDeleteTapped(placemark)
            } else {
                parent.onInfoTapped(placemark)
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(annotations: [MKPointAnnotation.example], onInfoTapped: { _ in }, onDeleteTapped: { _ in }, onLongPress: { _ in })
    }
}

public extension MKPointAnnotation {
    static var example: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = "London"
        annotation.subtitle = "Home to the 2012 Summer Olympics."
        annotation.coordinate = CLLocationCoordinate2D(latitude: 51.5, longitude: -0.13)
        return annotation
    }
}
