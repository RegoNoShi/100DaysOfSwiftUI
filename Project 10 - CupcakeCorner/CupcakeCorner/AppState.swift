//
//  AppState.swift
//  CupcakeCorner
//
//  Created by Massimo Omodei on 05.12.20.
//

import Foundation

class AppState: ObservableObject {
    @Published var order = Order()
}
