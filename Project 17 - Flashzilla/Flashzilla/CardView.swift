//
//  CardView.swift
//  Flashzilla
//
//  Created by Massimo Omodei on 21.02.21.
//

import SwiftUI

struct CardView: View {
    let card: Card
    var removal: ((Bool) -> Void)? = nil
    
    @Environment(\.accessibilityDifferentiateWithoutColor) private var differentiateWithoutColor
    @Environment(\.accessibilityEnabled) private var accessibilityEnabled
    @State private var isShowingAnswer = false
    @State private var isDragging = false
    @State private var offset = CGSize.zero
    @State private var feedback = UINotificationFeedbackGenerator()

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(
                    differentiateWithoutColor
                        ? Color.white
                        : Color.white.opacity(1 - Double(abs(offset.width / 50)))
                )
                .background(
                    differentiateWithoutColor || !isDragging
                        ? nil
                        : RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(offset.width > 0 ? Color.green : Color.red)
                )
                .shadow(radius: 10)

            VStack(spacing: 20) {
                if accessibilityEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                } else {
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)

                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(Double(offset.width / 5)))
        .offset(x: offset.width * 5, y: 0)
        .opacity(2 - Double(abs(offset.width / 50)))
        .accessibility(addTraits: .isButton)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                    feedback.prepare()
                    isDragging = true
                }
                .onEnded { _ in
                    if abs(offset.width) > 100 {
                        feedback.notificationOccurred(offset.width > 0 ? .success : .error)
                        removal?(offset.width > 0)
                        offset = .zero
                    } else {
                        withAnimation(.spring()) {
                            offset = .zero
                        }
                    }
                    isDragging = false
                }
        )
        .onTapGesture {
            isShowingAnswer.toggle()
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.example)
    }
}
