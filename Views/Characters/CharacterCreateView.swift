//
//  CharacterCreatView.swift
//  DNDCompanion
//
//  Created by Ivanov Garcia on 2/25/26.
// Modified by Jagadeesh on 4/15/26

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
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                sectionTitle("Basic Info")

                VStack(spacing: 14) {
                    minimalField(title: "Name", text: $name)
                    minimalField(title: "Race", text: $race)
                    minimalField(title: "Class", text: $characterClass)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Level")
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(Theme.textSecondary)

                        Stepper(value: $level, in: 1...20) {
                            Text("\(level)")
                                .foregroundColor(Theme.textPrimary)
                        }
                        .padding()
                        .background(Theme.card)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                }

                sectionTitle("Ability Scores")

                VStack(spacing: 12) {
                    statStepper(title: "STR", value: $strength)
                    statStepper(title: "DEX", value: $dexterity)
                    statStepper(title: "CON", value: $constitution)
                    statStepper(title: "INT", value: $intelligence)
                    statStepper(title: "WIS", value: $wisdom)
                    statStepper(title: "CHA", value: $charisma)
                }

                VStack(spacing: 12) {
                    Button {
                        strength = Int.random(in: 8...18)
                        dexterity = Int.random(in: 8...18)
                        constitution = Int.random(in: 8...18)
                        intelligence = Int.random(in: 8...18)
                        wisdom = Int.random(in: 8...18)
                        charisma = Int.random(in: 8...18)
                    } label: {
                        Text("Roll Stats")
                            .font(.headline)
                            .foregroundColor(Theme.textPrimary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.card)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }

                    Button {
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
                    } label: {
                        Text("Save Character")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.gold)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                }
                .padding(.top, 8)
            }
            .padding(20)
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("Create Character")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundColor(Theme.textSecondary)
    }

    private func minimalField(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .foregroundColor(Theme.textSecondary)

            TextField(title, text: text)
                .padding()
                .background(Theme.card)
                .foregroundColor(Theme.textPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }

    private func statStepper(title: String, value: Binding<Int>) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(Theme.textPrimary)

            Spacer()

            Stepper("", value: value, in: 1...20)
                .labelsHidden()

            Text("\(value.wrappedValue)")
                .frame(width: 28)
                .foregroundColor(Theme.textPrimary)
        }
        .padding()
        .background(Theme.card)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}
