//
//  Character.swift
//  DNDCompanion
//
//  Created by Ivanov Garcia on 2/25/26.
//

import Foundation
import SwiftData

@Model
class Character: Identifiable {
    
    var id: UUID
    var name: String
    var race: String
    var characterClass: String
    var level: Int
    
    var strength: Int
    var dexterity: Int
    var constitution: Int
    var intelligence: Int
    var wisdom: Int
    var charisma: Int
    
    var currentHP: Int
    var maxHP: Int
    var armorClass: Int
    
    init(
        name: String = "",
        race: String = "",
        characterClass: String = "",
        level: Int = 1,
        strength: Int = 10,
        dexterity: Int = 10,
        constitution: Int = 10,
        intelligence: Int = 10,
        wisdom: Int = 10,
        charisma: Int = 10,
        currentHP: Int = 10,
        maxHP: Int = 10,
        armorClass: Int = 10
    ) {
        self.id = UUID()
        self.name = name
        self.race = race
        self.characterClass = characterClass
        self.level = level
        
        self.strength = strength
        self.dexterity = dexterity
        self.constitution = constitution
        self.intelligence = intelligence
        self.wisdom = wisdom
        self.charisma = charisma
        
        self.currentHP = currentHP
        self.maxHP = maxHP
        self.armorClass = armorClass
    }
    
    // MARK: - Ability Modifier
    func modifier(for score: Int) -> Int {
        return (score - 10) / 2
    }
    
    // MARK: - Proficiency Bonus
    var proficiencyBonus: Int {
        switch level {
        case 1...4: return 2
        case 5...8: return 3
        case 9...12: return 4
        case 13...16: return 5
        default: return 6
        }
    }
}
