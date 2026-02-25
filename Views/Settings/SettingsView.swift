//
//  SettingsView.swift
//  DNDCompanion
//
//  Created by Ivanov Garcia on 2/25/26.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("soundEnabled") private var soundEnabled = true
    
    var body: some View {
        Form {
            Toggle("Sound Enabled", isOn: $soundEnabled)
        }
        .navigationTitle("Settings")
    }
}
