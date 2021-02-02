//
//  EditPlaceView.swift
//  BucketList
//
//  Created by Massimo Omodei on 01.02.21.
//

import SwiftUI
import MapKit

struct EditPlaceView: View {
    private enum LoadingState {
        case loading, loaded, failed
    }

    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var place: MKPointAnnotation
    @State private var loadingState = LoadingState.loading
    @State private var pages = [Page]()

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name", text: $place.wrappedTitle)

                    TextField("Description", text: $place.wrappedSubtitle)
                }

                Section(header: Text("Nearby")) {
                    if loadingState == .loaded {
                        List(pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline) +
                                Text(": ") +
                                Text(page.description)
                                    .italic()
                        }
                    } else if loadingState == .loading {
                        HStack {
                            Spacer()

                            ProgressView("Loading...")

                            Spacer()
                        }
                    } else {
                        Text("Something went wrong. Please, check your connection or try again later")
                    }
                }
            }
            .onAppear(perform: fetchNearbyPlaces)
            .navigationTitle("Edit Place")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }

    private func fetchNearbyPlaces() {
        print("Fetching nearby places")
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(place.coordinate.latitude)%7C\(place.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"

        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            loadingState = .failed
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let items = try? JSONDecoder().decode(Result.self, from: data) {
                pages = Array(items.query.pages.values).sorted()
                loadingState = .loaded
            } else {
                print("Bad response: \(data.debugDescription) \(error.debugDescription)")
                loadingState = .failed
            }
        }.resume()
    }
}

struct EditPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        EditPlaceView(place: MKPointAnnotation.example)
    }
}
