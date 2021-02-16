//
//  ContentView.swift
//  Accessibility
//
//  Created by Massimo Omodei on 15.02.21.
//

import SwiftUI

struct ContentView: View {
    private let pictures = [
        "ales-krivec-15949",
        "galina-n-189483",
        "kevin-horstmann-141705",
        "nicolas-tissot-335096"
    ]
    
    private let labels = [
        "Tulips",
        "Frozen tree buds",
        "Sunflowers",
        "Fireworks",
    ]

    @State private var selectedPicture = Int.random(in: 0...3)
    @State private var estimate = 25.0
    @State private var rating = 3

    var body: some View {
        VStack {
            // provide a meaningful label and specify that the image is a button
            Image(pictures[selectedPicture])
                .resizable()
                .scaledToFit()
                .accessibility(label: Text(labels[selectedPicture]))
                .accessibility(addTraits: .isButton)
                .accessibility(removeTraits: .isImage)
                .onTapGesture {
                    self.selectedPicture = Int.random(in: 0...3)
                }
            
            // hide from VoiceOver
            Image(decorative: "kevin-horstmann-141705")
                .accessibility(hidden: true)
            
            // use .combine to always read the two children together with a small pause
            // use .ignore and provide a custom label to provide a custom combined text
            VStack {
                Text("Your score is")
                Text("1000")
                    .font(.title)
            }
            .accessibilityElement(children: .ignore)
            .accessibility(label: Text("Your score is 1000"))
            
            // by default VoiceOver reads the values as percentages
            // use accessibility value to provide a custom text for Slider or Stepper
            Slider(value: $estimate, in: 0...50)
                .padding()
                .accessibility(value: Text("\(Int(estimate))"))
            
            Stepper("Rate our service: \(rating)/5", value: $rating, in: 1...5)
                .accessibility(value: Text("\(rating) out of 5"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
