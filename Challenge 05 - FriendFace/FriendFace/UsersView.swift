//
//  ContentView.swift
//  FriendFace
//
//  Created by Massimo Omodei on 17.12.20.
//

import SwiftUI

struct UsersView: View {
    @StateObject private var model = FriendFaceModel()

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
                        NavigationLink(destination: UserDetailsView(user: user,
                                                                    model: model)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(user.name)
                                        .font(.headline)

                                    Text(user.email)
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
    }
}
