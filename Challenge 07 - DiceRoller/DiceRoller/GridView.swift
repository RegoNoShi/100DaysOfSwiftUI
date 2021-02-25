//
//  GridView.swift
//  DiceRoller
//
//  Created by Massimo Omodei on 25.02.21.
//

import SwiftUI

struct GridView<Item, ItemView>: View where ItemView: View {
    var items: [Item]
    var viewForItem: (Item) -> ItemView

    var body: some View {
        GeometryReader { geometry in
            return body(for: GridLayout(itemCount: items.count, in: geometry.size))
        }
    }

    private func body(for layout: GridLayout) -> some View {
        ForEach(items.indices, id: \.self) { index in body(forItemAtIndex: index, in: layout) }
    }

    private func body(forItemAtIndex index: Int, in layout: GridLayout) -> some View {
        viewForItem(items[index])
            .frame(width: layout.itemSize.width, height: layout.itemSize.height, alignment: .center)
            .position(layout.location(ofItemAt: index))
    }
}

struct GridView_Previews: PreviewProvider {
    struct SampleItem: Hashable {
        var id: String
    }

    static var previews: some View {
        GridView(items: [SampleItem(id: "1"), SampleItem(id: "2")]) { item in Text(item.id) }
    }
}
