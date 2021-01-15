//
//  UserDetailsView.swift
//  FriendFace
//
//  Created by Massimo Omodei on 17.12.20.
//

import SwiftUI
import CoreData

struct UserDetailsView: View {
    private let user: User
    private let model: FriendFaceModel

    init(user: User, model: FriendFaceModel) {
        self.user = user
        self.model = model
    }

    private let userDetails: [UserEntry] = [
        UserEntry(key: \.displayableActiveState, name: "State"),
        UserEntry(key: \.wrappedEmail, name: "Email"),
        UserEntry(key: \.displayableAge, name: "Age"),
        UserEntry(key: \.wrappedAddress, name: "Address"),
        UserEntry(key: \.wrappedCompany, name: "Company"),
        UserEntry(key: \.displayableRegistrationDate, name: "Registered"),
        UserEntry(key: \.wrappedTags, name: "Tags")
    ]

    var body: some View {
        List {
            Text(user.wrappedAbout.trimmingCharacters(in: .whitespacesAndNewlines))
                .padding(.vertical)

            Section(header: Text("Details")) {
                ForEach(userDetails) { userDetail in
                    HStack {
                        Text(userDetail.name)
                            .fontWeight(.medium)

                        Spacer(minLength: 20)

                        Text(user[keyPath: userDetail.key])
                    }
                }
            }

            Section(header: Text("Friends")) {
                ForEach(model.friendsWithDetails(for: user)) { friend in
                    NavigationLink(destination: UserDetailsView(user: friend, model: model)) {
                        HStack {
                            Text(friend.wrappedName)
                                .font(.headline)

                            Spacer()

                            Text(friend.displayableShortActiveState)
                        }
                    }
                }
            }
        }
        .navigationTitle(user.wrappedName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct UserEntry: Identifiable {
    var id: String { name }
    let key: KeyPath<User, String>
    let name: String
}

struct UserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        return UserDetailsView(user: previewData.user, model: previewData.model)
    }
}
