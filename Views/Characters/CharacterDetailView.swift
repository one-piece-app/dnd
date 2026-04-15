//
//  CharacterDetailView.swift
//  DNDCompanion
//
//  Created by Ivanov Garcia on 2/25/26.
//

import SwiftUI
import UIKit

struct CharacterDetailView: View {

    @EnvironmentObject var vm: CoreDataViewModel

    @State private var selectedTab = 0
    @State private var showEdit = false

    @State private var rollResult = ""
    @State private var showRollAlert = false

    // SPELL FORM STATE
    @State private var showAddSpell = false
    @State private var newSpellName = ""
    @State private var newSpellLevel = 1
    @State private var newSpellDesc = ""

    var character: CharacterEntity

    var body: some View {
        VStack {

            Picker("", selection: $selectedTab) {
                Text("Stats").tag(0)
                Text("Skills").tag(1)
                Text("Spells").tag(2)
            }
            .pickerStyle(.segmented)
            .padding()

            switch selectedTab {
            case 0: statsView
            case 1: skillsView
            case 2: spellsView
            default: statsView
            }
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("Character")
        .toolbar {
            Button("Edit") {
                showEdit = true
            }
        }
        .navigationDestination(isPresented: $showEdit) {
            CharacterEditView(character: character)
        }
        .alert("Roll Result", isPresented: $showRollAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(rollResult)
        }
    }
}

//
// MARK: - STATS
//
extension CharacterDetailView {

    var statsView: some View {
        List {
            Section("Info") {
                Text(character.name ?? "")
                Text("\(character.race ?? "") \(character.characterClass ?? "")")
                Text("Level \(character.level)")
                Text("Proficiency +\(character.proficiencyBonus)")
            }

            Section("Ability Scores") {
                statRow("STR", character.str?.value ?? 10)
                statRow("DEX", character.dex?.value ?? 10)
                statRow("CON", character.con?.value ?? 10)
                statRow("INT", character.int?.value ?? 10)
                statRow("WIS", character.wis?.value ?? 10)
                statRow("CHA", character.cha?.value ?? 10)
            }

            Section("Combat") {
                HStack {
                    Text("HP")
                    Spacer()
                    Text("\(character.currentHP)/\(character.maxHP)")
                }

                HStack {
                    Text("Armor Class")
                    Spacer()
                    Text("\(character.armorClass)")
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Theme.background)
    }

    func statRow(_ label: String, _ value: Int16) -> some View {
        let mod = character.modifier(for: value)

        return HStack {
            Text(label)
            Spacer()
            Text("\(value)")
            Text(mod >= 0 ? "+\(mod)" : "\(mod)")
                .foregroundColor(Theme.gold)
        }
    }
}

//
// MARK: - SKILLS
//
extension CharacterDetailView {

    var skillsView: some View {
        List {
            ForEach(skillList, id: \.name) { skill in
                let abilityMod = character.modifier(for: skill.ability)
                let isProf = character.skillProficienciesSet.contains(skill.name)
                let total = abilityMod + (isProf ? character.proficiencyBonus : 0)

                HStack {
                    Button(skill.name) {
                        rollSkill(name: skill.name, bonus: total)
                    }

                    Spacer()

                    Toggle("", isOn: Binding(
                        get: { character.skillProficienciesSet.contains(skill.name) },
                        set: { val in
                            var profs = character.skillProficienciesSet
                            if val {
                                profs.insert(skill.name)
                            } else {
                                profs.remove(skill.name)
                            }
                            character.skillProficienciesSet = profs
                            vm.saveContext()
                        }
                    ))
                    .labelsHidden()

                    Text(total >= 0 ? "+\(total)" : "\(total)")
                        .bold()
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Theme.background)
    }

    var skillList: [(name: String, ability: Int16)] {
        [
            ("Acrobatics", character.dex?.value ?? 10),
            ("Animal Handling", character.wis?.value ?? 10),
            ("Arcana", character.int?.value ?? 10),
            ("Athletics", character.str?.value ?? 10),
            ("Deception", character.cha?.value ?? 10),
            ("History", character.int?.value ?? 10),
            ("Insight", character.wis?.value ?? 10),
            ("Intimidation", character.cha?.value ?? 10),
            ("Investigation", character.int?.value ?? 10),
            ("Medicine", character.wis?.value ?? 10),
            ("Nature", character.int?.value ?? 10),
            ("Perception", character.wis?.value ?? 10),
            ("Performance", character.cha?.value ?? 10),
            ("Persuasion", character.cha?.value ?? 10),
            ("Religion", character.int?.value ?? 10),
            ("Sleight of Hand", character.dex?.value ?? 10),
            ("Stealth", character.dex?.value ?? 10),
            ("Survival", character.wis?.value ?? 10)
        ]
    }

    func rollSkill(name: String, bonus: Int) {
        let roll = Int.random(in: 1...20)
        let total = roll + bonus

        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        rollResult = "\(name)\n\nRoll: \(roll)\nBonus: \(bonus)\nTotal: \(total)"
        showRollAlert = true
    }
}

//
// MARK: - SPELLS
//
extension CharacterDetailView {

    var spellsView: some View {
        let spells = character.spellsList()
        return VStack {

            List {
                ForEach(spells, id: \.objectID) { spell in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(spell.name ?? "").bold()
                        Text("Level \(spell.level)")
                        Text(spell.desc ?? "").font(.caption)

                        Toggle("Prepared", isOn: Binding(
                            get: { spell.isPrepared },
                            set: { _ in vm.toggleSpellPrepared(spell) }
                        ))
                    }
                }
                .onDelete { indexSet in
                    for i in indexSet {
                        vm.deleteSpell(spells[i])
                    }
                }
            }

            Button("Add Spell") {
                showAddSpell = true
            }
            .padding()
            .background(Theme.accent)
            .cornerRadius(12)
            .foregroundColor(.white)
        }
        .sheet(isPresented: $showAddSpell) {
            VStack(spacing: 20) {

                Text("New Spell")
                    .font(.headline)

                TextField("Name", text: $newSpellName)
                    .textFieldStyle(.roundedBorder)

                Stepper("Level \(newSpellLevel)", value: $newSpellLevel, in: 0...9)

                TextEditor(text: $newSpellDesc)
                    .frame(height: 100)
                    .border(Color.gray)

                Button("Save") {
                    vm.addSpell(
                        to: character,
                        name: newSpellName,
                        level: Int16(newSpellLevel),
                        desc: newSpellDesc
                    )

                    newSpellName = ""
                    newSpellDesc = ""
                    newSpellLevel = 1

                    showAddSpell = false
                }
                .buttonStyle(.borderedProminent)

                Button("Cancel") {
                    showAddSpell = false
                }
            }
            .padding()
        }
    }
}
