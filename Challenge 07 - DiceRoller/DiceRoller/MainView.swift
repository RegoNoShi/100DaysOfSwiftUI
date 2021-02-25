//
//  MainView.swift
//  DiceRoller
//
//  Created by Massimo Omodei on 25.02.21.
//

import SwiftUI

struct MainView: View {
    private let model = DiceRollerModel()
    
    var body: some View {
        TabView {
            RollView()
                .tabItem {
                    Image(systemName: "square.grid.2x2.fill")
                    
                    Text("Roll")
                }
            
            HistoryView()
                .tabItem {
                    Image(systemName: "clock.fill")
                    
                    Text("History")
                }
        }
        .environmentObject(model)
        .preferredColorScheme(.dark)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
