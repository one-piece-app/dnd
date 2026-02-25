//
//  DiceRoll.swift
//  DNDCompanion
//
//  Created by Ivanov Garcia on 2/25/26.
//

import Foundation
import SwiftData

@Model
class DiceRoll {
    var id: UUID
    var diceType: Int
    var quantity: Int
    var modifier: Int
    var results: [Int]
    var total: Int
    var timestamp: Date
    
    init(diceType: Int, quantity: Int, modifier: Int, results: [Int], total: Int) {
        self.id = UUID()
        self.diceType = diceType
        self.quantity = quantity
        self.modifier = modifier
        self.results = results
        self.total = total
        self.timestamp = Date()
    }
}
