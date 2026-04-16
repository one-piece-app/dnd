//
//  RootView.swift
//  DNDCompanion
//
//  Created by Ivanov Garcia on 2/25/26.
//

import SwiftUI

struct RootView: View {

    @EnvironmentObject var vm: CoreDataViewModel
    @State var preferredColumn = NavigationSplitViewColumn.sidebar
    @State var selectedCharacter: CharacterEntity? = nil


    var body: some View {
        NavigationSplitView(preferredCompactColumn: $preferredColumn) {
            List {
                ForEach(vm.characters) { character in
                    Button(character.name ?? "Unnamed Character") {
                        selectedCharacter = character
                        preferredColumn = .detail
                    }
                }
                .onDelete(perform: { offsets in
                    vm.deleteCharacter(indexSet: offsets)
                })
            }
            .listStyle(.plain)
            .toolbar {
                NavigationLink(destination: CharacterCreateView()) {
                    Image(systemName: "plus")
                }
            }
            .navigationTitle("Character Selector")
        } detail: {
            if let character = selectedCharacter {
                HomeView(character: character)
            } else {
                Button("Invalid state occured, press me to return!") {
                    preferredColumn = .sidebar
                }
            }
        }
        .background(Theme.background.ignoresSafeArea())
    }
}

