//
//  DiceRollerModel.swift
//  DiceRoller
//
//  Created by Massimo Omodei on 25.02.21.
//

import SwiftUI
import CoreHaptics
import Combine
import CoreData

class DiceRollerModel: ObservableObject {
    private let persistentContainer: NSPersistentContainer
    private let engine = DiceRollerModel.prepareHapticEngine()
    private var cancellableSet: Set<AnyCancellable> = []

    @Published private(set) var numberOfDice: Int = 1
    @Published private(set) var numberOfFaces: Int = 6
    @Published private(set) var lastRoll: Roll?
    @Published var rolls = [Roll]()
    
    var managedObjectContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    init() {
        persistentContainer = NSPersistentContainer(name: "DiceRoller")
        
        persistentContainer.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        CoreDataPublisher(request: Roll.fetchAllByTimestampDesc(), context: managedObjectContext)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] rolls in
                    self?.rolls = rolls
                })
            .store(in: &cancellableSet)
        
        loadSettings()
    }
        
    func roll(withFeedback feedbackEnabled: Bool = true) {
        let roll = Roll(context: managedObjectContext)
        roll.dice = (0 ..< numberOfDice).map { _ in "\(Int.random(in: 1 ... numberOfFaces))" }.joined(separator: ",")
        roll.id = Int64(rolls.count + 1)
        roll.timestamp = Date()
        roll.numberOfFaces = Int64(numberOfFaces)
        saveContext()
        
        lastRoll = roll
        
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
        
        saveSettings()
    }
    
    func clearLastRoll() {
        objectWillChange.send()
        
        lastRoll = nil
    }
    
    func clearHistory() {
        rolls.forEach {
            managedObjectContext.delete($0)
        }
        saveContext()
    }
    
    private func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private func loadSettings() {
        numberOfFaces = UserDefaults.standard.integer(forKey: "numberOfFaces")
        if numberOfFaces < 2 {
            numberOfFaces = 6
            saveSettings()
        }

        numberOfDice = UserDefaults.standard.integer(forKey: "numberOfDice")
        if numberOfDice < 1 {
            numberOfDice = 1
            saveSettings()
        }
    }
    
    private func saveSettings() {
        UserDefaults.standard.setValue(numberOfFaces, forKey: "numberOfFaces")
        UserDefaults.standard.setValue(numberOfDice, forKey: "numberOfDice")
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
    
    private static func prepareHapticEngine() -> CHHapticEngine? {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return nil }

        do {
            let engine = try CHHapticEngine()
            try engine.start()
            return engine
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
            return nil
        }
    }
}
