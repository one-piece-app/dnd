//
//  CharacterDetailView.swift
//  DNDCompanion
//
//  Created by Ivanov Garcia on 2/25/26.
// modified by jagadeesh on 4/15/26
import SwiftUI
import UIKit

struct CharacterDetailView: View {
    @EnvironmentObject var vm: CoreDataViewModel

    @State private var selectedTab = 0
    @State private var showEdit = false
    @State private var rollResult = ""
    @State private var showRollAlert = false

    @State private var showAddSpell = false
    @State private var newSpellName = ""
    @State private var newSpellLevel = 1
    @State private var newSpellDesc = ""

    var character: CharacterEntity

    var body: some View {
        VStack(spacing: 16) {
            headerCard

            Picker("", selection: $selectedTab) {
                Text("Stats").tag(0)
                Text("Skills").tag(1)
                Text("Spells").tag(2)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            Group {
                switch selectedTab {
                case 0:
                    statsView
                case 1:
                    skillsView
                case 2:
                    spellsView
                default:
                    statsView
                }
            }
        }
        .padding(.top, 8)
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("Character")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Edit") {
                showEdit = true
            }
        }
        .navigationDestination(isPresented: $showEdit) {
            CharacterEditView(character: character)
        }
        .alert("Roll Result", isPresented: $showRollAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(rollResult)
        }
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(character.name ?? "Unnamed Character")
                .font(.title2.weight(.semibold))
                .foregroundColor(Theme.textPrimary)

            Text("\(character.race ?? "Unknown") • \(character.characterClass ?? "Unknown")")
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)

            HStack(spacing: 10) {
                badge(title: "Level", value: "\(character.level)")
                badge(title: "AC", value: "\(character.armorClass)")
                badge(title: "HP", value: "\(character.currentHP)/\(character.maxHP)")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Theme.card)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Theme.gold.opacity(0.10), lineWidth: 1)
        )
        .padding(.horizontal)
    }

    private func badge(title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(Theme.textSecondary)

            Text(value)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(Theme.textPrimary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Theme.background.opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

// Stats
extension CharacterDetailView {
    var statsView: some View {
        ScrollView {
            VStack(spacing: 16) {
                detailCard(title: "Info") {
                    VStack(spacing: 12) {
                        infoRow("Name", character.name ?? "")
                        infoRow("Race", character.race ?? "")
                        infoRow("Class", character.characterClass ?? "")
                        infoRow("Level", "\(character.level)")
                        infoRow("Proficiency", "+\(character.proficiencyBonus)")
                    }
                }

                detailCard(title: "Ability Scores") {
                    VStack(spacing: 10) {
                        statRow("STR", character.str?.value ?? 10)
                        statRow("DEX", character.dex?.value ?? 10)
                        statRow("CON", character.con?.value ?? 10)
                        statRow("INT", character.int?.value ?? 10)
                        statRow("WIS", character.wis?.value ?? 10)
                        statRow("CHA", character.cha?.value ?? 10)
                    }
                }

                detailCard(title: "Combat") {
                    VStack(spacing: 12) {
                        infoRow("HP", "\(character.currentHP)/\(character.maxHP)")
                        infoRow("Armor Class", "\(character.armorClass)")
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 12)
        }
    }

    private func detailCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.headline)
                .foregroundColor(Theme.textPrimary)

            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Theme.card)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Theme.gold.opacity(0.08), lineWidth: 1)
        )
    }

    private func infoRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(Theme.textSecondary)

            Spacer()

            Text(value)
                .foregroundColor(Theme.textPrimary)
        }
    }

    func statRow(_ label: String, _ value: Int16) -> some View {
        let mod = character.modifier(for: value)

        return HStack {
            Text(label)
                .foregroundColor(Theme.textPrimary)
                .font(.headline)

            Spacer()

            Text("\(value)")
                .foregroundColor(Theme.textPrimary)

            Text(mod >= 0 ? "+\(mod)" : "\(mod)")
                .foregroundColor(Theme.gold)
                .frame(width: 36, alignment: .trailing)
        }
        .padding(.vertical, 6)
    }
}

// Skills
extension CharacterDetailView {
    var skillsView: some View {
        List {
            ForEach(skillList, id: \.name) { skill in
                let abilityMod = character.modifier(for: skill.ability)
                let isProf = character.skillProficienciesSet.contains(skill.name)
                let total = abilityMod + (isProf ? character.proficiencyBonus : 0)

                HStack(spacing: 12) {
                    Button {
                        rollSkill(name: skill.name, bonus: total)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(skill.name)
                                .foregroundColor(Theme.textPrimary)

                            Text(isProf ? "Proficient" : "Not Proficient")
                                .font(.caption)
                                .foregroundColor(Theme.textSecondary)
                        }
                    }
                    .buttonStyle(.plain)

                    Spacer()

                    Toggle(
                        "",
                        isOn: Binding(
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
                        )
                    )
                    .labelsHidden()

                    Text(total >= 0 ? "+\(total)" : "\(total)")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(Theme.gold)
                        .frame(width: 36, alignment: .trailing)
                }
                .padding(.vertical, 6)
                .listRowBackground(Theme.card)
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

// Spells
extension CharacterDetailView {
    var spellsView: some View {
        let spells = character.spellsList()

        return VStack(spacing: 12) {
            List {
                ForEach(spells, id: \.objectID) { spell in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(spell.name ?? "")
                            .font(.headline)
                            .foregroundColor(Theme.textPrimary)

                        Text("Level \(spell.level)")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)

                        Text(spell.desc ?? "")
                            .font(.caption)
                            .foregroundColor(Theme.textSecondary)

                        Toggle(
                            "Prepared",
                            isOn: Binding(
                                get: { spell.isPrepared },
                                set: { _ in vm.toggleSpellPrepared(spell) }
                            )
                        )
                        .foregroundColor(Theme.textPrimary)
                    }
                    .padding(.vertical, 6)
                    .listRowBackground(Theme.card)
                }
                .onDelete { indexSet in
                    for i in indexSet {
                        vm.deleteSpell(spells[i])
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Theme.background)

            Button("Add Spell") {
                showAddSpell = true
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Theme.accent)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .sheet(isPresented: $showAddSpell) {
            NavigationStack {
                VStack(spacing: 18) {
                    TextField("Name", text: $newSpellName)
                        .padding()
                        .background(Theme.card)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                    Stepper("Level \(newSpellLevel)", value: $newSpellLevel, in: 0...9)
                        .padding()
                        .background(Theme.card)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                    TextEditor(text: $newSpellDesc)
                        .frame(height: 120)
                        .padding(8)
                        .background(Theme.card)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

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
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Theme.accent)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                    Spacer()
                }
                .padding()
                .background(Theme.background.ignoresSafeArea())
                .navigationTitle("New Spell")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            showAddSpell = false
                        }
                    }
                }
            }
        }
    }
}
