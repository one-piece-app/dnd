//
//  DNDCompanionApp.swift
//  DNDCompanion
//
//  Created by Ivanov Garcia on 2/25/26.
//

import SwiftUI

@main
struct DNDCompanionApp: App {
    @StateObject private var vm = CoreDataViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(vm)
                .preferredColorScheme(.dark)
                .tint(Theme.gold)
        }
    }
}
