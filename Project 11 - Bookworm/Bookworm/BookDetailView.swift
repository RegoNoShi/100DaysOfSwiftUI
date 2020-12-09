//
//  BookDetailsView.swift
//  Bookworm
//
//  Created by Massimo Omodei on 09.12.20.
//

import SwiftUI
import CoreData

struct BookDetailView: View {
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.presentationMode) private var presentationMode

    @State private var showingAlert = false

    let book: Book

    private var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    Image(book.genre ?? "Fantasy")
                        .frame(maxWidth: geometry.size.width)

                    Text(book.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)
                }

                if let date = book.dateRead, let displayableDate = dateFormatter.string(for: date) {
                    HStack {
                        Spacer()

                        Text("Added: \(displayableDate)")
                            .foregroundColor(.secondary)
                            .font(.caption)
                            .padding(.trailing)
                    }
                }

                Text(book.author ?? "Unknown author")
                    .font(.title)
                    .foregroundColor(.secondary)

                if let review = book.review, review.count > 0 {
                    Text(review)
                        .padding()
                } else {
                    Text("No review")
                        .padding()
                }

                RatingView(rating: .constant(Int(book.rating)))
                    .font(.largeTitle)

                Spacer()
            }
        }
        .navigationTitle(Text(book.title ?? "Unknown Book"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button(action: {
                showingAlert.toggle()
            }) {
                Image(systemName: "trash")
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Delete book"), message: Text("Are you sure?"),
                  primaryButton: .destructive(Text("Delete")) { deleteBook()},
                  secondaryButton: .cancel()
            )
        }
    }

    private func deleteBook() {
        moc.delete(book)

        try? moc.save()

        presentationMode.wrappedValue.dismiss()
    }
}

struct BookDetailsView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        let book = Book(context: moc)
        book.title = "Test book"
        book.author = "Test author"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "This was a great book; I really enjoyed it."

        return NavigationView {
            BookDetailView(book: book)
        }
    }
}
