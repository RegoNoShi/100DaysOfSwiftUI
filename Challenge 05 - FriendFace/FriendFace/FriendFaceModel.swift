//
//  FriendFaceModel.swift
//  FriendFace
//
//  Created by Massimo Omodei on 17.12.20.
//

import Foundation

class FriendFaceModel: ObservableObject {
    private let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
    private let defaultSession = URLSession(configuration: .default)

    @Published private(set) var loadingError: String?
    @Published private(set) var loading = false
    @Published private(set) var users = [User]()

    private var loadUsersDataTask: URLSessionDataTask?

    init() {
        loadUsersData()
    }

    func loadUsersData() {
        loadUsersDataTask?.cancel()

        loading = true
        loadingError = nil
        
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

            guard let users = try? decoder.decode([User].self, from: data) else {
                DispatchQueue.main.async {
                    self.loading = false
                    self.loadingError = "Decoding error: unable to decode users"
                }
                return
            }

            DispatchQueue.main.async {
                self.loading = false
                self.users = users
            }
        }

        loadUsersDataTask?.resume()
    }
}
