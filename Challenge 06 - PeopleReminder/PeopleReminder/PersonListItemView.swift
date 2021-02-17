//
//  PersonListItem.swift
//  PeopleReminder
//
//  Created by Massimo Omodei on 16.02.21.
//

import SwiftUI

struct PersonListItemView: View {
    var person: Person
    
    var body: some View {
        HStack {
            if let image = person.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .frame(width: 100, alignment: .center)
            }
            
            VStack(alignment: .leading) {
                Text(person.name)
                    .font(.headline)
                
                Text("Last modified: \(person.formattedLastModified)")
                    .font(.subheadline)
            }
        }
    }
}

struct PersonListItemView_Previews: PreviewProvider {
    static var previews: some View {
        PersonListItemView(person: PeopleReminderModel.preview.people[0])
    }
}
