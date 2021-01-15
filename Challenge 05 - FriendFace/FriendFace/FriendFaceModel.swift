//
//  FriendFaceModel.swift
//  FriendFace
//
//  Created by Massimo Omodei on 17.12.20.
//

import CoreData

class FriendFaceModel: ObservableObject {
    private let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
    private let defaultSession = URLSession(configuration: .default)

    @Published private(set) var loadingError: String?
    @Published private(set) var loading = false

    private var loadUsersDataTask: URLSessionDataTask?
    @Published var moc: NSManagedObjectContext? {
        didSet {
            loadUsersData()
        }
    }
    @Published private(set) var users = [User]()

    func friendsWithDetails(for user: User) -> [User] {
        user.wrappedFriends.compactMap { friend in
            users.first(where: { $0.id == friend.id })
        }
    }

    func loadUsersData() {
        loadUsersDataTask?.cancel()

        loading = true
        loadingError = nil

        let usersFetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "User")

        do {
            let fetchedUsers = try moc!.fetch(usersFetchRequest) as! [User]
            if fetchedUsers.count > 0 {
                self.users = fetchedUsers
                loading = false
                return
            }
        } catch {
            print("Failed to fetch users: \(error)")
        }
        
        loadUsersDataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }

            guard error == nil, let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                DispatchQueue.main.async {
                    self.loading = false
                    self.loadingError = "DataTask error: \(error?.localizedDescription ?? "Unknown error")"
                }
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            guard let users = try? decoder.decode([UserData].self, from: data) else {
                DispatchQueue.main.async {
                    self.loading = false
                    self.loadingError = "Decoding error: unable to decode users"
                }
                return
            }

            DispatchQueue.main.async {
                for user in users {
                    let userMO = User(context: self.moc!)
                    userMO.id = user.id
                    userMO.name = user.name
                    userMO.address = user.address
                    userMO.email = user.email
                    userMO.company = user.company
                    userMO.about = user.about
                    userMO.isActive = user.isActive
                    userMO.age = Int16(user.age)
                    userMO.registered = user.registered
                    userMO.tags = user.tags.map { "#\($0)" }.joined(separator: ", ")
                    for friend in user.friends {
                        let friendMO = Friend(context: self.moc!)
                        friendMO.id = friend.id
                        friendMO.name = friend.name
                        friendMO.friendOf = userMO
                    }
                }
                try! self.moc?.save()
                self.loading = false
            }
        }

        loadUsersDataTask?.resume()
    }
}
