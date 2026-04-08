//
//  Spell.swift
//  DNDCompanion
//
//  Created by Ivanov Garcia on 4/8/26.
//

import Foundation
import SwiftData

@Model
class Spell {
    var id: UUID
    var name: String
    var level: Int
    var desc: String
    var isPrepared: Bool
    
    init(name: String, level: Int, desc: String, isPrepared: Bool = true) {
        self.id = UUID()
        self.name = name
        self.level = level
        self.desc = desc
        self.isPrepared = isPrepared
    }
}
