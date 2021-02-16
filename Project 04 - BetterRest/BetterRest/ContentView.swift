//
//  ContentView.swift
//  Better Rest
//
//  Created by Massimo Omodei on 20.10.20.
//

import SwiftUI
import CoreML

private var defaultWakeTime: Date {
    var components = DateComponents()
    components.hour = 7
    components.minute = 0
    return Calendar.current.date(from: components) ?? Date()
}

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 1

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("When do you want to wake up?")) {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .accessibility(label: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Text Label@*/Text("Label")/*@END_MENU_TOKEN@*/)
                }

                Section(header: Text("Desired amount of sleep")) {
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                    .accessibility(label: Text("\(sleepAmount, specifier: "%g") hours"))
                }

                Section(header: Text("Daily coffee intake")) {
                    Stepper(value: $coffeeAmount, in: 0...20) {
                        Text("\(coffeeAmount) \(coffeeAmount == 1 ? "cup" : "cups")")
                    }
                    .accessibility(label: Text("\(coffeeAmount) \(coffeeAmount == 1 ? "cup" : "cups")"))
                }

                Section(header: Text("Your ideal bedtime is…")) {
                    Text(calculateBedtime())
                }
            }
            .navigationBarTitle("Better Rest")
        }
    }

    private func calculateBedtime() -> String {
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60

        guard let model = try? SleepCalculator(configuration: MLModelConfiguration()),
              let prediction = try? model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount)) else {
            return "Sorry, there was a problem calculating your bedtime."
        }

        let sleepTime = wakeUp - prediction.actualSleep
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: sleepTime)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
