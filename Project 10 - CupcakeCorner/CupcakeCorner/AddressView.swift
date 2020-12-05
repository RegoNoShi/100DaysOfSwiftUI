//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Massimo Omodei on 05.12.20.
//

import SwiftUI


struct AddressView: View {
    @ObservedObject var state: AppState

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $state.order.name)
                TextField("Street Address", text: $state.order.streetAddress)
                TextField("City", text: $state.order.city)
                TextField("Zip", text: $state.order.zip)
                    .keyboardType(.numberPad)
            }

            Section {
                NavigationLink(destination: CheckoutView(state: state)) {
                    Text("Check out")
                }
            }
            .disabled(!state.order.hasValidAddress)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(state: AppState())
    }
}
