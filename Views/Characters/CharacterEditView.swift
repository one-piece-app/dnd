//
//  CharacterEditView.swift
//  DNDCompanion
//
//  Created by Ivanov Garcia on 2/25/26.
//

import SwiftUI
import SwiftData

struct CharacterEditView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var character: Character
    
    var body: some View {
        Form {
            
            Section("Basic Info") {
                TextField("Name", text: $character.name)
                TextField("Race", text: $character.race)
                TextField("Class", text: $character.characterClass)
                Stepper("Level \(character.level)", value: $character.level, in: 1...20)
            }
            
            Section("Ability Scores") {
                Stepper("STR \(character.strength)", value: $character.strength, in: 1...20)
                Stepper("DEX \(character.dexterity)", value: $character.dexterity, in: 1...20)
                Stepper("CON \(character.constitution)", value: $character.constitution, in: 1...20)
                Stepper("INT \(character.intelligence)", value: $character.intelligence, in: 1...20)
                Stepper("WIS \(character.wisdom)", value: $character.wisdom, in: 1...20)
                Stepper("CHA \(character.charisma)", value: $character.charisma, in: 1...20)
            }
            
            Section("Combat") {
                Stepper("Current HP \(character.currentHP)", value: $character.currentHP, in: 0...999)
                Stepper("Max HP \(character.maxHP)", value: $character.maxHP, in: 1...999)
                Stepper("Armor Class \(character.armorClass)", value: $character.armorClass, in: 1...50)
            }
            
            Button("Done") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle("Edit Character")
    }
}
