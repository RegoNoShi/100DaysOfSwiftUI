//
//  DiceRollerModel.swift
//  DiceRoller
//
//  Created by Massimo Omodei on 25.02.21.
//

import Foundation
import CoreHaptics

struct Roll: Codable {
    let dice: [Int]
    let number: Int
    let time: Date
    
    init(dice: [Int], number: Int, time: Date = Date()) {
        self.dice = dice
        self.number = number
        self.time = time
    }
    
    var total: Int {
        dice.reduce(0, { $0 + $1 })
    }
}

class DiceRollerModel: ObservableObject {
    private let historyUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("history.json")
    private var engine: CHHapticEngine?
    private var internalDice = [Int]()
    private(set) var rollCount: Int = 0
    private(set) var numberOfDice: Int = 1
    private(set) var numberOfFaces: Int = 6
    private(set) var rolls = [Roll]() {
        didSet {
            save()
        }
    }
    
    init() {
        load()
        prepareHaptics()
    }
    
    func roll(withFeedback feedbackEnabled: Bool = true) {
        objectWillChange.send()
        
        if numberOfDice > internalDice.count {
            internalDice.append(contentsOf: Array(repeating: -1, count: numberOfDice - internalDice.count))
        } else if numberOfDice < internalDice.count {
            internalDice.removeLast(internalDice.count - numberOfDice)
        }
        for i in internalDice.indices {
            internalDice[i] = Int.random(in: 1 ... numberOfFaces)
        }

        rollCount += 1
        rolls.insert(Roll(dice: internalDice, number: rollCount), at: 0)
        
        if feedbackEnabled {
            rollFeedback()
        }
    }
    
    func update(numberOfDice: Int? = nil, numberOfFaces: Int? = nil) {
        guard numberOfDice != self.numberOfDice || numberOfFaces != self.numberOfFaces else {
            return
        }
        
        objectWillChange.send()
        
        self.numberOfDice = numberOfDice ?? self.numberOfDice
        self.numberOfFaces = numberOfFaces ?? self.numberOfFaces
        
        save()
    }
    
    func clearHistory() {
        objectWillChange.send()
        
        rolls.removeAll()
        rollCount = 0
    }
    
    private func load() {
        numberOfFaces = UserDefaults.standard.integer(forKey: "numberOfFaces")
        if numberOfFaces < 2 {
            numberOfFaces = 6
            save()
        }

        numberOfDice = UserDefaults.standard.integer(forKey: "numberOfDice")
        if numberOfDice < 1 {
            numberOfDice = 1
            save()
        }
        
        if let data = try? Data(contentsOf: historyUrl),
           let rolls = try? JSONDecoder().decode([Roll].self, from: data) {
            self.rolls = rolls
            rollCount = rolls.count
        }
    }
    
    private func save() {
        if let data = try? JSONEncoder().encode(rolls) {
            try? data.write(to: historyUrl)
        }
        
        UserDefaults.standard.setValue(numberOfFaces, forKey: "numberOfFaces")
        UserDefaults.standard.setValue(numberOfDice, forKey: "numberOfDice")
    }
    
    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    private func rollFeedback() {
        guard let engine = engine else { return }
        
        let events: [CHHapticEvent] = stride(from: 1.0, to: 5.0, by: 1.0).map { value in
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1 / Float(value))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1 - 1 / Float(value))
            return CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: value / 10)
        }

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            try engine.makePlayer(with: pattern).start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
}
