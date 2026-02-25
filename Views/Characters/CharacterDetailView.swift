//
//  CharacterDetailView.swift
//  DNDCompanion
//
//  Created by Ivanov Garcia on 2/25/26.
//

import SwiftUI
import UIKit

struct CharacterDetailView: View {
    
    @State private var selectedTab = 0
    @State private var showEdit = false
    
    @State private var rollResult: String = ""
    @State private var showRollAlert = false
    
    @State private var proficientSkills: Set<String> = []
    
    var character: Character
    
    var body: some View {
        VStack {
            
            Picker("View", selection: $selectedTab) {
                Text("Stats").tag(0)
                Text("Skills").tag(1)
            }
            .pickerStyle(.segmented)
            .padding()
            
            if selectedTab == 0 {
                statsView
            } else {
                skillsView
            }
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("Character Sheet")
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

// MARK: Stats View
extension CharacterDetailView {
    
    var statsView: some View {
        List {
            Section("Basic Info") {
                Text(character.name)
                    .font(.headline)
                
                Text("\(character.race) \(character.characterClass)")
                Text("Level \(character.level)")
                Text("Proficiency Bonus: +\(character.proficiencyBonus)")
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
                    Text("\(character.currentHP) / \(character.maxHP)")
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
    
    private func statRow(_ label: String, _ value: Int) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text("\(value)")
            
            let modifier = character.modifier(for: value)
            Text(modifier >= 0 ? "+\(modifier)" : "\(modifier)")
                .foregroundColor(Theme.gold)
        }
    }
}

// MARK: Skills View
extension CharacterDetailView {
    
    var skillsView: some View {
        List {
            ForEach(skillList, id: \.name) { skill in
                skillRow(skill)
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
    
    func skillRow(_ skill: (name: String, ability: Int)) -> some View {
        let abilityModifier = character.modifier(for: skill.ability)
        let isProficient = proficientSkills.contains(skill.name)
        let totalBonus = abilityModifier + (isProficient ? character.proficiencyBonus : 0)
        
        return HStack {
            
            Button {
                rollSkill(name: skill.name, bonus: totalBonus)
            } label: {
                Text(skill.name)
            }
            
            Spacer()
            
            Toggle("", isOn: Binding(
                get: { proficientSkills.contains(skill.name) },
                set: { newValue in
                    if newValue {
                        proficientSkills.insert(skill.name)
                    } else {
                        proficientSkills.remove(skill.name)
                    }
                }
            ))
            .labelsHidden()
            
            Text(totalBonus >= 0 ? "+\(totalBonus)" : "\(totalBonus)")
                .bold()
        }
    }
    
    func rollSkill(name: String, bonus: Int) {
        let roll = Int.random(in: 1...20)
        let total = roll + bonus
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        rollResult = "\(name)\n\nRoll: \(roll)\nBonus: \(bonus)\nTotal: \(total)"
        showRollAlert = true
    }
}
