//
//  ContentView.swift
//  Cupcake Corner
//
//  Created by Massimo Omodei on 18.11.20.
//

import SwiftUI

struct OrderView: View {
    @ObservedObject var state = AppState()

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $state.order.type) {
                        ForEach(0..<Order.types.count) {
                            Text(Order.types[$0])
                        }
                    }

                    Stepper(value: $state.order.quantity, in: 3...20) {
                        Text("Number of cakes: \(state.order.quantity)")
                    }
                }

                Section {
                    Toggle(isOn: $state.order.specialRequestEnabled.animation()) {
                        Text("Any special requests?")
                    }

                    if state.order.specialRequestEnabled {
                        Toggle(isOn: $state.order.extraFrosting) {
                            Text("Add extra frosting")
                        }

                        Toggle(isOn: $state.order.addSprinkles) {
                            Text("Add sprinkles")
                        }
                    }
                }

                Section {
                    NavigationLink(destination: AddressView(state: state)) {
                        Text("Delivery details")
                    }
                }
            }
            .navigationBarTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView()
    }
}
