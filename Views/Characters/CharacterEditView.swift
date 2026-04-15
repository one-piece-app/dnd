//
//  CharacterEditView.swift
//  DNDCompanion
//
//  Created by Ivanov Garcia on 2/25/26.
//

import SwiftUI

struct CharacterEditView: View {
    @EnvironmentObject var vm: CoreDataViewModel
    @Environment(\.dismiss) private var dismiss

    var character: CharacterEntity

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

    @State private var currentHP = 10
    @State private var maxHP = 10
    @State private var armorClass = 10

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

            Section("Combat") {
                Stepper("Current HP \(currentHP)", value: $currentHP, in: 0...999)
                Stepper("Max HP \(maxHP)", value: $maxHP, in: 1...999)
                Stepper("Armor Class \(armorClass)", value: $armorClass, in: 1...50)
            }

            Button("Done") {
                vm.updateCharacter(
                    character,
                    name: name,
                    characterClass: characterClass,
                    race: race,
                    level: Int16(level),
                    currentHP: Int16(currentHP),
                    maxHP: Int16(maxHP),
                    armorClass: Int16(armorClass),
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
        .navigationTitle("Edit Character")
        .onAppear {
            name = character.name ?? ""
            race = character.race ?? ""
            characterClass = character.characterClass ?? ""
            level = Int(character.level)

            strength = Int(character.str?.value ?? 10)
            dexterity = Int(character.dex?.value ?? 10)
            constitution = Int(character.con?.value ?? 10)
            intelligence = Int(character.int?.value ?? 10)
            wisdom = Int(character.wis?.value ?? 10)
            charisma = Int(character.cha?.value ?? 10)

            currentHP = Int(character.currentHP)
            maxHP = Int(character.maxHP)
            armorClass = Int(character.armorClass)
        }
    }
}
