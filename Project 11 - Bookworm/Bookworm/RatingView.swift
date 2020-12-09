//
//  RatingView.swift
//  Bookworm
//
//  Created by Massimo Omodei on 09.12.20.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int

    var label = ""

    var maximumRating = 5

    var offImage: Image?
    var onImage = Image(systemName: "star.fill")

    var offColor = Color.gray
    var onColor = Color.yellow

    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }

    var body: some View {
        HStack {
            if !label.isEmpty {
                Text(label)

                Spacer()
            }

            ForEach(1 ..< maximumRating + 1) { index in
                image(for: index)
                    .foregroundColor(index > rating ? offColor : onColor)
                    .onTapGesture {
                        rating = index
                    }
            }
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: .constant(3), label: "Rating")
    }
}
