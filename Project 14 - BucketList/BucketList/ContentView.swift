//
//  ContentView.swift
//  BucketList
//
//  Created by Massimo Omodei on 31.01.21.
//

import SwiftUI
import MapKit
import LocalAuthentication

struct ContentView: View {
    @State private var isLocked = true
    @State private var alert: Alert!

    var body: some View {
        let showingAlert = Binding<Bool>(
            get: {
                alert != nil
            }, set: { showing in
                alert = showing ? alert : nil
            })

        return ZStack {
            if isLocked {
                Button("Unlock Places") {
                    authenticate()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
            } else {
                PlacesView() {
                    alert = $0
                }
            }
        }
        .onAppear(perform: authenticate)
        .alert(isPresented: showingAlert) {
            alert
        }
    }

    private func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock your places."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
                DispatchQueue.main.async {
                    isLocked = !success
                }
            }
        } else {
            let alertAlreadyShown = UserDefaults.standard.bool(forKey: "alertAlreadyShown")
            if !alertAlreadyShown {
                UserDefaults.standard.set(true, forKey: "alertAlreadyShown")
                DispatchQueue.main.async {
                    alert = Alert(title: Text("Warning"),
                                  message: Text("Your device does not support biometric authentication, your data will not be protected"),
                                  dismissButton: .default(Text("Ok")) { isLocked = false })
                }
            } else {
                DispatchQueue.main.async {
                    isLocked = false
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
