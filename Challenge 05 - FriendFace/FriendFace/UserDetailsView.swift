//
//  UserDetailsView.swift
//  FriendFace
//
//  Created by Massimo Omodei on 17.12.20.
//

import SwiftUI

struct UserDetailsView: View {
    private let user: User
    @StateObject private var model: FriendFaceModel

    init(user: User, model: FriendFaceModel) {
        self.user = user
        _model = StateObject(wrappedValue: model)
    }

    private let userDetails: [UserEntry] = [
        UserEntry(key: \.displayableActiveState, name: "State"),
        UserEntry(key: \.email, name: "Email"),
        UserEntry(key: \.displayableAge, name: "Age"),
        UserEntry(key: \.address, name: "Address"),
        UserEntry(key: \.company, name: "Company"),
        UserEntry(key: \.displayableRegistrationDate, name: "Registered"),
        UserEntry(key: \.displayableTags, name: "Tags")
    ]

    private var friendsWithDetails: [User] {
        user.friends.compactMap {
            friend in model.users.first(where: { $0.id == friend.id })
        }
    }

    var body: some View {
        List {
            Text(user.about.trimmingCharacters(in: .whitespacesAndNewlines))
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
                ForEach(friendsWithDetails) { friend in
                    NavigationLink(destination: UserDetailsView(user: friend, model: model)) {
                        HStack {
                            Text(friend.name)
                                .font(.headline)

                            Spacer()

                            Text(friend.displayableShortActiveState)
                        }
                    }
                }
            }
        }
        .navigationTitle(user.name)
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
        UserDetailsView(user: User(id: "1", isActive: true, name: "Test User", age: 23, company: "Test Company", email: "test@test.com", address: "Test Avenue 1, Test City", about: "Lorem ipsum bla bla bla", registered: Date(), tags: ["Tag1", "Tag2"], friends: [Friend(id: "2", name: "Test Friend")]),
                        model: FriendFaceModel())
    }
}
