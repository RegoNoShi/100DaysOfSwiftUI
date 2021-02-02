//
//  PlacesView.swift
//  BucketList
//
//  Created by Massimo Omodei on 02.02.21.
//

import SwiftUI
import MapKit

struct PlacesView: View {
    @State private var locations = [CodableMKPointAnnotation]()
    @State private var selectedPlace: MKPointAnnotation?
    @State private var showingEditPlace = false
    var showAlert: (Alert) -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            MapView(annotations: locations, onInfoTapped: openInfo, onDeleteTapped: deletePlace, onLongPress: addPlace)

            Text("Long press on the map\nto add a new place")
                .multilineTextAlignment(.center)
                .padding(8)
                .background(Color.black.opacity(0.7))
                .font(.caption)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .padding(20)
        }
        .onChange(of: locations, perform: { _ in saveData() })
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: loadData)
        .sheet(isPresented: $showingEditPlace) {
            if let selectedPlace = selectedPlace {
                EditPlaceView(place: selectedPlace)
            }
        }
    }

    private func addPlace(location: CLLocationCoordinate2D) {
        let newLocation = CodableMKPointAnnotation  ()
        newLocation.coordinate = location
        newLocation.title = "Example location"
        locations.append(newLocation)
        selectedPlace = newLocation
        showingEditPlace = true
    }

    private func deletePlace(annotation: MKPointAnnotation) {
        if let toRemove = locations.firstIndex(where: { $0 == annotation}) {
            locations.remove(at: toRemove)
        }
    }

    private func openInfo(annotation: MKPointAnnotation) {
        showAlert(Alert(title: Text(selectedPlace?.title ?? "Unknown"),
                        message: Text(selectedPlace?.subtitle ?? "Missing place information"),
                        primaryButton: .default(Text("Ok")),
                        secondaryButton: .default(Text("Edit")) {
                            selectedPlace = annotation
                            showingEditPlace = true
                        }))
    }

    private var documentDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private func loadData() {
        do {
            let url = documentDirectory.appendingPathComponent("SavedLocations")
            let data = try Data(contentsOf: url)
            locations = try JSONDecoder().decode([CodableMKPointAnnotation].self, from: data)
        } catch {
            print("Unable to load locations: \(error.localizedDescription)")
        }
    }

    private func saveData() {
        do {
            let url = documentDirectory.appendingPathComponent("SavedLocations")
            let data = try JSONEncoder().encode(locations)
            try data.write(to: url , options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save locations: \(error.localizedDescription)")
        }
    }
}

struct PlacesView_Previews: PreviewProvider {
    static var previews: some View {
        PlacesView() { _ in }
    }
}
