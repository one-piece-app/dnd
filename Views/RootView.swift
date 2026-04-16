//
//  RootView.swift
//  DNDCompanion
//
//  Created by Ivanov Garcia on 2/25/26.
//  modified by jagadeesh on 4/15/26
import SwiftUI

struct RootView: View {
    @EnvironmentObject var vm: CoreDataViewModel

    var body: some View {
        NavigationStack {
            Group {
                if vm.characters.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .font(.system(size: 40))
                            .foregroundColor(Theme.gold)

                        Text("No Characters Yet")
                            .font(.headline)
                            .foregroundColor(Theme.textPrimary)

                        Text("Tap + to create your first character.")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Theme.background)
                } else {
                    List {
                        ForEach(vm.characters) { character in
                            NavigationLink(destination: HomeView(character: character)) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(character.name ?? "Unnamed Character")
                                        .font(.headline)
                                        .foregroundColor(Theme.textPrimary)

                                    Text("\(character.race ?? "Unknown") • \(character.characterClass ?? "Unknown") • Level \(character.level)")
                                        .font(.subheadline)
                                        .foregroundColor(Theme.textSecondary)
                                }
                                .padding(.vertical, 8)
                            }
                        }
                        .onDelete { offsets in
                            vm.deleteCharacter(indexSet: offsets)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Theme.background)
                }
            }
            .navigationTitle("Characters")
            .toolbar {
                NavigationLink(destination: CharacterCreateView()) {
                    Image(systemName: "plus")
                        .foregroundColor(Theme.gold)
                }
            }
        }
    }
}
