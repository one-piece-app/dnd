//
//  CharacterDetailView.swift
//  DNDCompanion
//
//  Created by Ivanov Garcia on 2/25/26.
//

import SwiftUI
import SwiftData
import UIKit

struct CharacterDetailView: View {
    
    @Environment(\.modelContext) private var context
    @Query var spells: [Spell]
    
    @State private var selectedTab = 0
    @State private var showEdit = false
    
    @State private var rollResult = ""
    @State private var showRollAlert = false
    
    @State private var proficientSkills: Set<String> = []
    
    // SPELL FORM STATE
    @State private var showAddSpell = false
    @State private var newSpellName = ""
    @State private var newSpellLevel = 1
    @State private var newSpellDesc = ""
    
    var character: Character
    
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
                Text(character.name)
                Text("\(character.race) \(character.characterClass)")
                Text("Level \(character.level)")
                Text("Proficiency +\(character.proficiencyBonus)")
            }
            
            Section("Ability Scores") {
                statRow("STR", character.strength)
                statRow("DEX", character.dexterity)
                statRow("CON", character.constitution)
                statRow("INT", character.intelligence)
                statRow("WIS", character.wisdom)
                statRow("CHA", character.charisma)
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
    
    func statRow(_ label: String, _ value: Int) -> some View {
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
                let isProf = proficientSkills.contains(skill.name)
                let total = abilityMod + (isProf ? character.proficiencyBonus : 0)
                
                HStack {
                    Button(skill.name) {
                        rollSkill(name: skill.name, bonus: total)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: Binding(
                        get: { isProf },
                        set: { val in
                            if val {
                                proficientSkills.insert(skill.name)
                            } else {
                                proficientSkills.remove(skill.name)
                            }
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
    
    var skillList: [(name: String, ability: Int)] {
        [
            ("Acrobatics", character.dexterity),
            ("Animal Handling", character.wisdom),
            ("Arcana", character.intelligence),
            ("Athletics", character.strength),
            ("Deception", character.charisma),
            ("History", character.intelligence),
            ("Insight", character.wisdom),
            ("Intimidation", character.charisma),
            ("Investigation", character.intelligence),
            ("Medicine", character.wisdom),
            ("Nature", character.intelligence),
            ("Perception", character.wisdom),
            ("Performance", character.charisma),
            ("Persuasion", character.charisma),
            ("Religion", character.intelligence),
            ("Sleight of Hand", character.dexterity),
            ("Stealth", character.dexterity),
            ("Survival", character.wisdom)
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
        VStack {
            
            List {
                ForEach(spells) { spell in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(spell.name).bold()
                        Text("Level \(spell.level)")
                        Text(spell.desc).font(.caption)
                        
                        Toggle("Prepared", isOn: Binding(
                            get: { spell.isPrepared },
                            set: { spell.isPrepared = $0 }
                        ))
                    }
                }
                .onDelete { indexSet in
                    for i in indexSet {
                        context.delete(spells[i])
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
                    let spell = Spell(
                        name: newSpellName,
                        level: newSpellLevel,
                        desc: newSpellDesc
                    )
                    
                    context.insert(spell)
                    
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
