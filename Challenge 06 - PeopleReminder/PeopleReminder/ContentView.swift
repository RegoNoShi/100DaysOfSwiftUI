//
//  ContentView.swift
//  PeopleReminder
//
//  Created by Massimo Omodei on 16.02.21.
//

import SwiftUI

struct ContentView: View {
    @State private var showingAddPerson = false
    @StateObject private var model: PeopleReminderModel
    
    init(model: PeopleReminderModel) {
        _model = StateObject(wrappedValue: model)
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(model.people.sorted()) { person in
                    NavigationLink(destination: PersonDetailsView(person: person, model: model)) {
                        PersonListItemView(person: person)
                    }
                }
                .onDelete(perform: model.delete)
            }
            .navigationTitle("People Reminder")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddEditPersonView(model: model)) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: PeopleReminderModel.preview)
    }
}
