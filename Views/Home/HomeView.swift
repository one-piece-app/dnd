//
//  HomeView.swift
//  DNDCompanion
//
//  Created by Ivanov Garcia on 2/25/26.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var vm: CoreDataViewModel
    @State private var showSettings = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                
                if let character = vm.characters.first {
                    characterCard(character)
                }
                
                navButton("Dice Roller", system: "die.face.5.fill") {
                    DiceView()
                }
                
                navButton("Character Sheet", system: "person.crop.rectangle") {
                    if let character = vm.characters.first {
                        CharacterDetailView(character: character)
                    }
                }
                
                navButton("Notes", system: "book.fill") {
                    NotesListView()
                }
                
                Button {
                    showSettings = true
                } label: {
                    Label("Settings", systemImage: "gearshape.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.card)
                        .cornerRadius(14)
                        .foregroundColor(.white)
                }
            }
            .padding()
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("D&D Companion")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
    
    func characterCard(_ character: CharacterEntity) -> some View {
        VStack(spacing: 8) {
            Text(character.name ?? "")
                .font(.title2)
                .bold()
            
            Text("\(character.race ?? "") \(character.characterClass ?? "")")
                .foregroundColor(Theme.textSecondary)
            
            Text("Level \(character.level)")
                .foregroundColor(Theme.gold)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Theme.card)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.4), radius: 8)
    }
    
    func navButton<Destination: View>(_ title: String,
                                      system: String,
                                      @ViewBuilder destination: @escaping () -> Destination) -> some View {
        NavigationLink(destination: destination()) {
            Label(title, systemImage: system)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Theme.card)
                .cornerRadius(14)
                .foregroundColor(.white)
        }
    }
}
