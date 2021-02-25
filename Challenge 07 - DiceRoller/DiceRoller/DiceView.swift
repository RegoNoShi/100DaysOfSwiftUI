//
//  DiceView.swift
//  DiceRoller
//
//  Created by Massimo Omodei on 24.02.21.
//

import SwiftUI

struct DiceView: View {
    let dice: Int
        
    var body: some View {
        GeometryReader { geo in
            body(withDiceSize: min(geo.size.height, geo.size.width, UIScreen.minScreenSize / 2))
                .frame(width: geo.size.width, height: geo.size.height)
        }
    }
    
    private func body(withDiceSize diceSize: CGFloat) -> some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: diceSize / 5)
                .strokeBorder(Color.black, lineWidth: 3, antialiased: true)
                .background(RadialGradient(gradient: Gradient(colors: [.pink, .orange]), center: .center, startRadius: 0, endRadius: diceSize * 0.75))
                .frame(width: diceSize, height: diceSize)
            
            Text("\(dice)")
                .foregroundColor(.white)
                .font(Font.custom("Dice", size: diceSize / 2))
        }
        .clipShape(RoundedRectangle(cornerRadius: diceSize / 5))
    }
}

private extension UIScreen {
    static let minScreenSize = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
}

struct DiceView_Previews: PreviewProvider {
    static var previews: some View {
        DiceView(dice: Int.random(in: 0 ... 100))
            .previewLayout(.fixed(width: 200, height: 150))
    }
}
