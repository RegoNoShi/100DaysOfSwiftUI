//
//  AddBookView.swift
//  Bookworm
//
//  Created by Massimo Omodei on 09.12.20.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.presentationMode) private var presentationMode
    private static let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]

    @State private var title = ""
    @State private var author = ""
    @State private var genre = AddBookView.genres[0]
    @State private var review = ""
    @State private var rating = 3

    private var isInvalidBook: Bool {
        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            author.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Book's title", text: $title)

                    TextField("Author's name", text: $author)

                    Picker("Genre", selection: $genre) {
                        ForEach(AddBookView.genres, id: \.self) {
                            Text($0)
                        }
                    }
                }

                Section {
                    RatingView(rating: $rating, label: "Rating")

                    TextField("Write a review (optional)", text: $review)
                        .lineLimit(10)
                }

                Section {
                    Button("Save") {
                        let newBook = Book(context: moc)
                        newBook.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
                        newBook.author = author.trimmingCharacters(in: .whitespacesAndNewlines)
                        newBook.review = review.trimmingCharacters(in: .whitespacesAndNewlines)
                        newBook.genre = genre
                        newBook.rating = Int16(rating)
                        newBook.id = UUID()
                        newBook.dateRead = Date()
                        try? moc.save()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(isInvalidBook)
                }
            }
            .navigationTitle("Add Book")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
