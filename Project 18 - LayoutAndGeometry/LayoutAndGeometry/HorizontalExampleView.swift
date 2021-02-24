//
//  HorizontalExampleView.swift
//  LayoutAndGeometry
//
//  Created by Massimo Omodei on 23.02.21.
//

import SwiftUI

struct HorizontalExampleView: View {
    var body: some View {
        GeometryReader { fullView in
            VStack {
                Spacer()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(0..<50) { index in
                            GeometryReader { geo in
                                VStack {
                                    Spacer()
                                    
                                    Image("picture")
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .frame(width: min(fullView.size.height, fullView.size.width) * 0.7,
                                               height: min(fullView.size.height, fullView.size.width) * 0.7)
                                        .rotation3DEffect(
                                            .degrees(-Double(geo.frame(in: .global).midX - fullView.size.width / 2) / 10),
                                            axis: (x: 0.0, y: 1.0, z: 0.0))
                                    
                                    Spacer()
                                }
                            }
                            .frame(width: min(fullView.size.height, fullView.size.width) * 0.7,
                                   height: min(fullView.size.height, fullView.size.width))
                        }
                    }
                    .padding(.horizontal, (fullView.size.width - min(fullView.size.height, fullView.size.width) * 0.7) / 2)
                }
                .frame(height: min(fullView.size.height, fullView.size.width))
                
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.horizontal)
    }
}

struct HorizontalExampleView_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalExampleView()
    }
}
