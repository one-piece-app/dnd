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
        NavigationStack {
            List {
                ForEach(vm.characters) { character in
                    NavigationLink(character.name ?? "Unnamed Character") {
                        HomeView(character: character)
                    }
                }
                .onDelete(perform: { offsets in
                    vm.deleteCharacter(indexSet: offsets)
                })
            }
            .toolbar {
                NavigationLink(destination: CharacterCreateView()) {
                    Image(systemName: "plus")
                }
            }
            .background(Theme.background.ignoresSafeArea())
            .navigationTitle("Character Selector")
        }
    }
}

