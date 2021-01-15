//
//  PreviewData.swift
//  FriendFace
//
//  Created by Massimo Omodei on 16.01.21.
//

import CoreData

struct PreviewData {
    let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    let model = FriendFaceModel()
    let user: User

    init() {
        model.moc = moc

        user = User(context: moc)
        user.id = "1"
        user.name = "Test"
        user.email = "test@test.com"
        user.age = 23
        user.company = "Test Company"
        user.address = "Test Avenue 1, Test City"
        user.about = "Lorem ipsum bla bla bla"
        user.registered = Date()
        user.tags = "#Tag1, #Tag2"
    }
}

let previewData = PreviewData()
