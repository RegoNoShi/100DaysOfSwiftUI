//
//  ContentView.swift
//  UnitConverter
//
//  Created by Massimo Omodei on 14.10.20.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedUnitType = 0
    @State private var quantity: String = ""
    @State private var sourceUnit = 0
    @State private var destinationUnit = 1

    var resultQuantity: Double? {
        guard let sourceQuantity = Double(quantity) else { return nil }

        return selectedUnits[destinationUnit].fromBaseUnit(selectedUnits[sourceUnit].toBaseUnit(sourceQuantity))
    }

    var selectedUnits: [Unit] {
        unitTypes[selectedUnitType].units
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Source")) {
                    Picker(selection: $selectedUnitType, label: Text("Type")) {
                        ForEach(0 ..< unitTypes.count) {
                            Text(unitTypes[$0].name)
                        }
                    }
                    .onChange(of: selectedUnitType) { _ in
                        quantity = ""
                    }


                    Picker(selection: $sourceUnit, label: Text("Unit")) {
                        ForEach(0 ..< selectedUnits.count) {
                            Text(selectedUnits[$0].name)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    TextField("Quantity", text: $quantity)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.center)
                }


                Button(action: {
                    if let resultQuantity = resultQuantity {
                        quantity = String(format: "%.2f", resultQuantity)
                    } else {
                        quantity = ""
                    }
                    let tmpUnit = sourceUnit
                    sourceUnit = destinationUnit
                    destinationUnit = tmpUnit
                }, label: {
                    HStack(alignment: .center) {
                        Spacer()
                        Image(systemName: "arrow.up.arrow.down.circle.fill")
                        Spacer()
                    }
                })


                Section(header: Text("Result")) {
                    Picker(selection: $destinationUnit, label: Text("Unit")) {
                        ForEach(0 ..< selectedUnits.count) {
                            Text(selectedUnits[$0].name)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    HStack {
                        Spacer()

                        if let resultQuantity = resultQuantity {
                            Text("\(resultQuantity, specifier: "%.2f") \(selectedUnits[destinationUnit].symbol)")
                        } else {
                            Text("Insert source quantity")
                        }

                        Spacer()
                    }
                }
            }
            .navigationTitle("Unit Converter")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Unit {
    var name: String
    var symbol: String
    var toBaseUnit: (Double) -> Double
    var fromBaseUnit: (Double) -> Double
}

let temperatureUnits = [
    Unit(name: "Celsius", symbol: "°C", toBaseUnit: { qty in qty }, fromBaseUnit: { qty in qty }),
    Unit(name: "Fahrenheit", symbol: "°F", toBaseUnit: { qty in (qty - 32) * 5 / 9 }, fromBaseUnit: { qty in (qty * 9 / 5) + 32 }),
    Unit(name: "Kelvin", symbol: "K", toBaseUnit: { qty in qty - 273.15 }, fromBaseUnit: { qty in qty + 273.15 }),
]

let lengthUnits = [
    Unit(name: "Meter", symbol: "m", toBaseUnit: { qty in qty }, fromBaseUnit: { qty in qty }),
    Unit(name: "Kilometer", symbol: "km", toBaseUnit: { qty in qty * 1000 }, fromBaseUnit: { qty in qty / 1000 }),
    Unit(name: "Centimeter", symbol: "cm", toBaseUnit: { qty in qty / 100 }, fromBaseUnit: { qty in qty * 100 }),
    Unit(name: "Millimeter", symbol: "mm", toBaseUnit: { qty in qty / 1000}, fromBaseUnit: { qty in qty * 1000 }),
]

let unitTypes: [(name: String, units: [Unit])] = [
    ("Temperature", temperatureUnits),
    ("Length", lengthUnits)
]
