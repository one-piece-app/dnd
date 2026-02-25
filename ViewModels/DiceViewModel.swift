//
//  DiceViewModel.swift
//  DNDCompanion
//
//  Created by Ivanov Garcia on 2/25/26.
//

import Foundation
import SwiftData

class DiceViewModel: ObservableObject {
    
    func rollDice(diceType: Int, quantity: Int, modifier: Int) -> (results: [Int], total: Int) {
        var rolls: [Int] = []
        
        for _ in 0..<quantity {
            rolls.append(Int.random(in: 1...diceType))
        }
        
        let total = rolls.reduce(0, +) + modifier
        
        return (rolls, total)
    }
}
