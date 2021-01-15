//
//  ContentView.swift
//  FriendFace
//
//  Created by Massimo Omodei on 17.12.20.
//

import SwiftUI
import CoreData

struct UsersView: View {
    @Environment(\.managedObjectContext) private var moc
    @StateObject private var model = FriendFaceModel()
    @State private var appeared = false

    var body: some View {
        let errorAlertShown = Binding(
            get: { return model.loadingError != nil },
            set: { _, _ in  }
        )

        return NavigationView {
            Group {
                if model.loading {
                    ProgressView("Loading users data")
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    List(model.users) { user in
                        NavigationLink(destination: UserDetailsView(user: user, model: model)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(user.wrappedName)
                                        .font(.headline)

                                    Text(user.wrappedEmail)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()

                                Text("\(user.age)yo")
                                    .font(.headline)
                            }
                        }
                    }
                }
            }
            .onAppear {
                guard !appeared else { return }
                appeared = true
                model.moc = moc
            }
            .navigationTitle("FriendFace")
            .alert(isPresented: errorAlertShown) {
                Alert(title: Text("Error loading users data"),
                      message: Text("Please check your connection and retry"),
                      dismissButton: .default(Text("Retry")) {
                        model.loadUsersData()
                      })
            }
        }
    }
}

struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        UsersView()
            .environment(\.managedObjectContext, previewData.moc)
    }
}
