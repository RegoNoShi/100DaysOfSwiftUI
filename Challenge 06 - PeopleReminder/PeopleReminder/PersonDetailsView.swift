//
//  PersonDetailsView.swift
//  PeopleReminder
//
//  Created by Massimo Omodei on 16.02.21.
//

import SwiftUI

struct PersonDetailsView: View {
    var person: Person
    var model: PeopleReminderModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                if let image = person.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 5)
                }
                    
                Text("Last Modified: \(person.formattedLastModified)")
                    .font(.caption)
            }
            .padding()
            
            VStack(alignment: .leading) {
                Text(person.email != nil || person.phoneNumber != nil ? "Contact details:" : "No contact details")
                    .font(.title)
                
                if let email = person.email {
                    Text("Email: \(email)")
                }
                
                if let phoneNumber = person.phoneNumber {
                    Text("Phone Number: \(phoneNumber)")
                }
                
                if let notes = person.notes {
                    Text("Notes:")
                        .font(.title)
                        .padding(.top)
                    
                    Text(notes)
                }
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding()
            
            MapView(location: .constant(person.location))
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fill)
                .padding()
        }
        .navigationTitle(person.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AddEditPersonView(model: model, person: person)) {
                    Image(systemName: "pencil")
                }
            }
        }
    }
}

struct PersonDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PersonDetailsView(person: PeopleReminderModel.preview.people[0],
                          model: PeopleReminderModel.preview)
    }
}
