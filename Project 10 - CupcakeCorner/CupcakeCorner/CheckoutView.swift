//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Massimo Omodei on 05.12.20.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var state: AppState
    @State private var orderConfirmationShown = false
    @State private var orderConfirmationTitle: LocalizedStringKey = ""
    @State private var orderConfirmationMessage: LocalizedStringKey = ""

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
        .alert(isPresented: $orderConfirmationShown) {
            Alert(title: Text(orderConfirmationTitle), message: Text(orderConfirmationMessage), dismissButton: .default(Text("OK")))
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
            guard let responseData = responseData,
                  let decodedOrder = try? JSONDecoder().decode(Order.self, from: responseData) else {
                print("Unable to decode the response: \(error?.localizedDescription ?? "Unknown error").")
                orderConfirmationTitle = "Something went wrong :("
                orderConfirmationMessage = "Unable to place your order. Please check your network and retry."
                orderConfirmationShown.toggle()
                return
            }

            orderConfirmationTitle = "Your order is on its way!"
            orderConfirmationMessage = "You paid $\(decodedOrder.cost, specifier: "%.2f") for \(decodedOrder.quantity) cupcakes."
            orderConfirmationShown.toggle()
        }.resume()
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(state: AppState())
    }
}
