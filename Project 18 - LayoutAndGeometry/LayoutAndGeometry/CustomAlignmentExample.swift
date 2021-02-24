//
//  CustomAlignmentExample.swift
//  LayoutAndGeometry
//
//  Created by Massimo Omodei on 23.02.21.
//

import SwiftUI

extension VerticalAlignment {
    struct MidAccountAndName: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            d[.top]
        }
    }

    static let midAccountAndName = VerticalAlignment(MidAccountAndName.self)
}

struct CustomAlignmentExample: View {
    var body: some View {
        HStack(alignment: .midAccountAndName) {
            VStack {
                Text("@handle")
                    .alignmentGuide(.midAccountAndName) { d in d[VerticalAlignment.center] }
                
                Image("picture")
                    .resizable()
                    .frame(width: 64, height: 64)
            }

            VStack {
                Text("Full name:")
                    .alignmentGuide(.midAccountAndName) { d in d[VerticalAlignment.center] }
                
                Text("John Doe")
                    .font(.largeTitle)
            }
        }
    }
}

struct CustomAlignmentExample_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlignmentExample()
    }
}
