//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Massimo Omodei on 05.12.20.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var state: AppState
    @State private var alertShown = false
    @State private var alertTitle: LocalizedStringKey = ""
    @State private var alertMessage: LocalizedStringKey = ""

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Image("cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)

                    Text("Your total is $\(state.order.cost, specifier: "%.2f")")
                        .font(.title)

                    Button("Place Order") {
                        placeOrder()
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $alertShown) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    private func placeOrder() {
        guard let requestData = try? JSONEncoder().encode(state.order) else {
            fatalError("Unable to encode order")
        }

        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = requestData

        URLSession.shared.dataTask(with: request) { responseData, _, error in
            guard error == nil, let responseData = responseData,
                  let decodedOrder = try? JSONDecoder().decode(Order.self, from: responseData) else {
                print("Unable to decode the response: \(error?.localizedDescription ?? "Unknown error").")
                alertTitle = "Something went wrong :("
                alertMessage = "Unable to place your order. Please check your network and retry."
                alertShown.toggle()
                return
            }

            alertTitle = "Your order is on its way!"
            alertMessage = "You paid $\(decodedOrder.cost, specifier: "%.2f") for \(decodedOrder.quantity) cupcakes."
            alertShown.toggle()
        }.resume()
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(state: AppState())
    }
}
