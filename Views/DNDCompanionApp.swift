//
//  DNDCompanionApp.swift
//  DNDCompanion
//
//  Created by Ivanov Garcia on 2/25/26.
//

import SwiftUI
import SwiftData

@main
struct DNDCompanionApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(.dark)
                .tint(Theme.gold)
        }
        .modelContainer(for: [
            Character.self,
            Note.self,
            DiceRoll.self
        ])
    }
}
