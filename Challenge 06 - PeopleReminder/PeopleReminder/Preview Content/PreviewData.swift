//
//  PreviewData.swift
//  PeopleReminder
//
//  Created by Massimo Omodei on 16.02.21.
//

import Foundation

extension PeopleReminderModel {
    static var preview: PeopleReminderModel {
        let model = PeopleReminderModel(jsonFileName: "mockPeople")
        if model.people.count == 0 {
            model.savePerson(Person(name: "Tall guy"))
            model.savePerson(Person(name: "John Doe", email: "john.doe@email.com"))
            model.savePerson(Person(name: "Maria Rossi", email: nil, phoneNumber: "+1 555 555 5555"))
        }
        return model
    }
}
