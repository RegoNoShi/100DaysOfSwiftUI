//
//  SettingsView.swift
//  Flashzilla
//
//  Created by Massimo Omodei on 22.02.21.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State private var reproposeWrongCards = UserDefaults.standard.bool(forKey: "ReproposeWrongCards")
    
    var body: some View {
        NavigationView {
            Form {
                Toggle("Repropose wrong cards", isOn: $reproposeWrongCards)
            }
            .navigationBarTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done", action: dismiss)
                }
            }
            .listStyle(GroupedListStyle())
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onChange(of: reproposeWrongCards) { _ in saveSettings() }
    }

    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }

    func saveSettings() {
        UserDefaults.standard.set(reproposeWrongCards, forKey: "ReproposeWrongCards")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
