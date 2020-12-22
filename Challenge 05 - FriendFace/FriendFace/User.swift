//
//  User.swift
//  FriendFace
//
//  Created by Massimo Omodei on 17.12.20.
//

import Foundation

struct User: Codable, Hashable, Identifiable {
    let id: String
    let isActive: Bool
    let name: String
    let age: Int
    let company: String
    let email: String
    let address: String
    let about: String
    let registered: Date
    let tags: [String]
    let friends: [Friend]
}

struct Friend: Codable, Hashable, Identifiable {
    let id: String
    let name: String
}
