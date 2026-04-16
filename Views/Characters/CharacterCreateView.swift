//
//  CharacterCreatView.swift
//  DNDCompanion
//
//  Created by Ivanov Garcia on 2/25/26.
//

import SwiftUI

struct CharacterCreateView: View {

    @EnvironmentObject var vm: CoreDataViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var race = ""
    @State private var characterClass = ""
    @State private var level = 1
    
    @State private var strength = 10
    @State private var dexterity = 10
    @State private var constitution = 10
    @State private var intelligence = 10
    @State private var wisdom = 10
    @State private var charisma = 10

    var body: some View {
        Form {
            Section("Basic Info") {
                TextField("Name", text: $name)
                TextField("Race", text: $race)
                TextField("Class", text: $characterClass)
                Stepper("Level \(level)", value: $level, in: 1...20)
            }
            
            Section("Ability Scores") {
                Stepper("STR \(strength)", value: $strength, in: 1...20)
                Stepper("DEX \(dexterity)", value: $dexterity, in: 1...20)
                Stepper("CON \(constitution)", value: $constitution, in: 1...20)
                Stepper("INT \(intelligence)", value: $intelligence, in: 1...20)
                Stepper("WIS \(wisdom)", value: $wisdom, in: 1...20)
                Stepper("CHA \(charisma)", value: $charisma, in: 1...20)
            }
            
            Button("Roll Stats") {
                strength = Int.random(in: 8...18)
                dexterity = Int.random(in: 8...18)
                constitution = Int.random(in: 8...18)
                intelligence = Int.random(in: 8...18)
                wisdom = Int.random(in: 8...18)
                charisma = Int.random(in: 8...18)
            }
            
            Button("Save Character") {
                vm.addCharacter(
                    name: name,
                    characterClass: characterClass,
                    race: race,
                    level: Int16(level),
                    strength: Int16(strength),
                    dexterity: Int16(dexterity),
                    constitution: Int16(constitution),
                    wisdom: Int16(wisdom),
                    intelligence: Int16(intelligence),
                    charisma: Int16(charisma)
                )
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle("Create Character")
    }
}
