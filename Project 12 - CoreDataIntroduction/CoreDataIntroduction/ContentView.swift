//
//  ContentView.swift
//  CoreDataIntroduction
//
//  Created by Massimo Omodei on 14.12.20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var moc
    @State private var lastNameFilter = "A"

    private var filter: Filter? {
        lastNameFilter.isEmpty ? nil : .BeginsWith(key: "lastName", value: lastNameFilter)
    }

    var body: some View {
        VStack {
            FilteredList(filter: filter, sortDescriptors: [NSSortDescriptor(keyPath: \Singer.lastName, ascending: false)]) { (singer: Singer) in
                Section(header: Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")) {
                    ForEach(singer.singsArray, id: \.self) { song in
                        Text(song.wrappedTitle)
                    }
                }
            }
            
            Button("Add Examples") {
                let adele = Singer(context: moc)
                adele.firstName = "Adele"
                adele.lastName = "Adkins"

                let someoneLikeYou = Song(context: moc)
                someoneLikeYou.title = "Someone Like You"
                someoneLikeYou.sungBy = adele

                let hello = Song(context: moc)
                hello.title = "Hello"
                hello.sungBy = adele

                let sheeran = Singer(context: moc)
                sheeran.firstName = "Ed"
                sheeran.lastName = "Sheeran"

                let thinkingOutLoud = Song(context: moc)
                thinkingOutLoud.title = "Thinking Out Loud"
                thinkingOutLoud.sungBy = sheeran

                let swift = Singer(context: moc)
                swift.firstName = "Taylor"
                swift.lastName = "Swift"

                let lover = Song(context: moc)
                lover.title = "Lover"
                lover.sungBy = swift

                try? moc.save()
            }
            .padding(.bottom)

            Button("Show A") {
                lastNameFilter = "A"
            }
            .padding(.bottom)

            Button("Show S") {
                lastNameFilter = "S"
            }
            .padding(.bottom)

            Button("Show all") {
                lastNameFilter = ""
            }
            .padding(.bottom)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
