//
//  RootView.swift
//  DNDCompanion
//
//  Created by Ivanov Garcia on 2/25/26.
//

import SwiftUI
import SwiftData

struct RootView: View {
    
    @Query var characters: [Character]
    
    var body: some View {
        NavigationStack {
            if characters.isEmpty {
                CharacterCreateView()
            } else {
                HomeView()
            }
        }
        .background(Theme.background.ignoresSafeArea())
    }
}
