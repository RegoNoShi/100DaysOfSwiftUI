//
//  SettingsView.swift
//  DiceRoller
//
//  Created by Massimo Omodei on 25.02.21.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var model: DiceRollerModel
    @Environment(\.presentationMode) private var presentationMode
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
        UINavigationBar.appearance().tintColor = .systemBlue
    }

    var body: some View {
        let numberOfFaces = Binding {
            model.numberOfFaces
        } set: {
            model.update(numberOfFaces: $0)
        }

        let numberOfDice = Binding {
            model.numberOfDice
        } set: {
            model.update(numberOfDice: $0)
        }

        return NavigationView {
            Form {
                Picker("Number of faces", selection: numberOfFaces) {
                    ForEach(2 ..< 101, id: \.self) {
                        Text("\($0)")
                    }
                }

                Picker("Number of dice", selection: numberOfDice) {
                    ForEach(1 ..< 101, id: \.self) {
                        Text("\($0)")
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .onDisappear() {
            UINavigationBar.appearance().tintColor = .white
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(DiceRollerModel())
    }
}
