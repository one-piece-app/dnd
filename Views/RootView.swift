//
//  RootView.swift
//  DNDCompanion
//
//  Created by Ivanov Garcia on 2/25/26.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var vm: CoreDataViewModel
    
    var body: some View {
        NavigationStack {
            if vm.characters.isEmpty {
                CharacterCreateView()
            } else {
                HomeView()
            }
        }
        .background(Theme.background.ignoresSafeArea())
    }
}
