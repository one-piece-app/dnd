//
//  Note.swift
//  DNDCompanion
//
//  Created by Ivanov Garcia on 2/25/26.
//

import Foundation
import SwiftData

@Model
class Note {
    var id: UUID
    var title: String
    var content: String
    var category: String
    var timestamp: Date
    
    init(title: String = "", content: String = "", category: String = "Campaign") {
        self.id = UUID()
        self.title = title
        self.content = content
        self.category = category
        self.timestamp = Date()
    }
}
