//
//  CoreDataViewModel.swift
//  DNDCompanion
//
//  Created by Reese Roberts on 3/5/26.
//

import Foundation
import CoreData

class CoreDataViewModel: ObservableObject {
    let container: NSPersistentContainer = {
        NSPersistentContainer(name: "CoreData")
    }()

    @Published var campaigns: [CampaignEntity] = []
    @Published var characters : [CharacterEntity] = []
    @Published var dice: [DiceEntity] = []
    @Published var notes: [NoteEntity] = []
    @Published var stats: [CharacterStatEntity] = []

    var campaignsCount: Int {
        do {
            return try container.viewContext.count(for: CampaignEntity.fetchRequest())
        } catch {
            print("Error counting CampaignEntity: \(error.localizedDescription)")
            return 0
        }
    }

    var characterCount: Int {
        do {
            return try container.viewContext.count(for: CharacterEntity.fetchRequest())
        } catch {
            print("Error counting CampaignEntity: \(error.localizedDescription)")
            return 0
        }
    }

    init() {
        print("\ninit")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                print("Error loading persistent sore: \(error.localizedDescription)")
            } else {
                print ("Core Data loaded")
            }
        }

        fetchAll();
    }

    func fetchAll () {
        characters = fetch(entityName: "CharacterEntity")
        campaigns = fetch(entityName: "CampaignEntity")
        dice = fetch(entityName: "DiceEntity")
        notes = fetch(entityName: "NoteEntity")
        stats = fetch(entityName: "CharacterStatEntity")
    }

    func fetch<T: NSFetchRequestResult>(entityName: String) -> [T] {
        do {
            let request = NSFetchRequest<T>(entityName: entityName)
            return try container.viewContext.fetch(request)
        } catch let error as NSError {
            print("Error fetching: \(error.localizedDescription)")
            return [];
        }
    }

    func saveContext() {
        print("Attempting to save data")
        do {
            try container.viewContext.save()
            print("viewContext saved")
            container.viewContext.refreshAllObjects()
            print("refresh completed")
            fetchAll()

        } catch {
            print("Failed to save context: \(error.localizedDescription)")
            container.viewContext.rollback()
        }
    }

    //

    //

    //

    //=~ Character

    //~ Constructor
    func addCharacter (
        name: String = "john doe",
        characterClass: String = "Fighter",
        race: String = "Human",
        maxHP: Int16 = 10,
        level: Int16 = 1,
        strength: Int16 = 10,
        dexterity: Int16 = 10,
        constitution: Int16 = 10,
        wisdom: Int16 = 10,
        intelligence: Int16 = 10,
        charisma: Int16 = 10,
    ) {
        let entity = CharacterEntity(context: container.viewContext)
        entity.name = name
        entity.characterClass = characterClass
        entity.race = race
        entity.maxHP = maxHP
        entity.level = level

        entity.stats = NSSet(array: [
          addStat(name: "str", value: strength),
          addStat(name: "dex", value: dexterity),
          addStat(name: "con", value: constitution),
          addStat(name: "wis", value: wisdom),
          addStat(name: "int", value: intelligence),
          addStat(name: "cha", value: charisma)
        ])

        self.characters.append(entity);
        saveContext()
    }

    //~ Descructor
    func deleteCharacter(indexSet: IndexSet) {
        for i in indexSet {container.viewContext.delete(characters[i])}
        for i in indexSet {characters.remove(at: i)}
        saveContext()
    }

    func deleteCharacter(obj: CharacterEntity) {
        if let index = characters.firstIndex(where: {$0 == obj}) {characters.remove(at: index)}
        container.viewContext.delete(obj)
        saveContext()
    }

    //=~ CharacterStat Private Constructor
    //~ Constructor
    /// Weak entity CharacterStats is only created on Strong entity Character creation, and deltion is cascaded with parent entity
    private func addStat(name: String, value: Int16) -> CharacterStatEntity {
        let entity = CharacterStatEntity(context: container.viewContext)
        entity.name = name
        entity.value = value
        return entity
    }


    //~ Descructor
    // N/A


    //=~ Campaign

    //~ Constructor
    //~ Descructor


    //=~ Dice

    //~ Constructor
    func roll(
        d2: Int = 0,
        d4: Int = 0,
        d6: Int = 0,
        d8: Int = 0,
        d10: Int = 0,
        d12: Int = 0,
        d20: Int = 0,
        d100: Int = 0,
    ) -> DiceRollEntity {
        return roll(dN: [
            (sides: 2, quantity: d2),
            (sides: 4, quantity: d4),
            (sides: 6, quantity: d6),
            (sides: 8, quantity: d8),
            (sides: 10, quantity: d10),
            (sides: 12, quantity: d12),
            (sides: 20, quantity: d20),
            (sides: 100, quantity: d100),
        ])
    }

    func roll(
        dN: [(sides: Int16, quantity: Int)],
    ) -> DiceRollEntity {
        let parent = DiceRollEntity(context: container.viewContext)
        parent.timestamp = Date()

        for (sides: sides, quantity: quant) in dN {
            guard quant > 0 else { continue }
            for _ in 1...quant {
                print("sides: \(sides), quant: \(quant)")
                let child = DieEntity(context: container.viewContext)
                child.sides = sides as Int16
                child.value = Int16.random(in: 1...sides)

                print(parent.dice?.count ?? -1)
                parent.dice = parent.dice?.adding(child) as NSSet? ?? NSSet(objects: [child])
                print(parent.dice?.count ?? -1)
            }
        }

        return parent;
    }

    //~ Descructor
    /// Deletes DiceResultEntity, assumes that DiceResultEntity isn't in a published list
    func deleteDiceRoll(
        obj: DiceRollEntity,
    ) {
        if let index = dice.firstIndex(where: {$0 == obj}) {dice.remove(at: index)}
        container.viewContext.delete(obj)
        saveContext()
    }


    //=~ Note

    //~ Constructor
    func addNote(
      title: String = "Title",
      content: String,
      category: String? = nil,
      timestamp: Date = Date()
    ) {
        let entity = NoteEntity(context: container.viewContext)
        entity.title = title
        entity.category = category
        entity.content = content
        entity.timestamp = timestamp

        self.notes.append(entity);
        saveContext()
    }

    private func deleteNote(indexSet: IndexSet) {
        for i in indexSet { container.viewContext.delete(notes[i]) }
        for i in indexSet { notes.remove(at: i) }
        saveContext()
    }

    //~ Descructor
}

//=~ Extensions of CoreData Entity Types

extension CharacterEntity {
    public func statsList() -> [CharacterStatEntity]? {
        guard let statsSet = stats as? Set<CharacterStatEntity> else { return nil }
        return statsSet.map{$0}
    }

    private func stat(named name: String) -> CharacterStatEntity? {
        return statsList()?.first { $0.name == name }
    }

    var int: CharacterStatEntity? { stat(named: "int") }
    var str: CharacterStatEntity? { stat(named: "str") }
    var dex: CharacterStatEntity? { stat(named: "dex") }
    var con: CharacterStatEntity? { stat(named: "con") }
    var wis: CharacterStatEntity? { stat(named: "wis") }
    var cha: CharacterStatEntity? { stat(named: "cha") }

    var armorClass: Int16 { 10 + (dex?.modifier ?? 0) }
}

extension CharacterStatEntity {
    var modifier: Int16 {(value - (value >= 10 ? 10 : 11)) / 2}
}

extension DiceEntity { }

/*extension DiceResultEntity {
    public func results() -> [DiceResultDieEntity]? {
        guard diceSet = resultDice as? Set<DiceResultDieEntity> else {return nil}
        return diceSet.map{$0}
    }
}*/

extension DiceRollEntity {
    var diceList: [DieEntity] {
        if self.dice == nil {print("dice is null"); return [] }
        guard let diceSet = self.dice as? Set<DieEntity> else {print("failed cast"); return []}
        return diceSet.map{$0}
    }

    var valueList: [Int] {self.diceList.map{Int($0.value)}}
    var sum: Int? {self.valueList.reduce(0, +)}
}

extension NoteEntity { }

//=~ Debug Preview for CoreData

import SwiftUI

struct CoreDataViewModelDebugView: View {
    @StateObject var vm = CoreDataViewModel()
    @State var userInput: String = ""
    @State var selectedCharacter: CharacterEntity?


    var CharacterPage: some View {
        NavigationView{
            VStack {
                Text("\(vm.characters.count) - \(vm.characterCount)")
                HStack {
                    TextField("Character Name", text: $userInput).padding()
                        .frame(height: 55).frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.leading)

                    Button(action: {
                        vm.addCharacter(name: userInput, characterClass: "wizard", race: "high elf")
                        print("pressed")
                    }, label: {
                        Text("Add")
                    })
                    .frame(height: 55).frame(maxWidth: 90)
                    .foregroundColor(Color.white).background(Color.blue)
                    .cornerRadius(10)
                    .padding(.trailing)
                }

                HStack {
                    List {
                        ForEach(vm.characters) { character in
                            Button(action: {
                                self.selectedCharacter = character
                            }) {
                                Text(character.name!)
                            }
                        }.onDelete(perform: vm.deleteCharacter)
                    }
                    .listStyle(.plain)

                    List {
                        if let character = selectedCharacter {
                            ForEach(character.statsList() ?? []) { stat in
                                Text("\(stat.name!) - \(stat.value)/(\(stat.modifier))")
                                    .monospaced()
                            }
                        }
                    }
                }
            } // VStack
        } // NavigationView
    }

    var DiceRollerPage : some View {
        VStack {
            Button(action: {
                let roll: DiceRollEntity = vm.roll(d20: 2)
                print(roll.valueList)
                print("sum: \(roll.sum ?? -20)")
                vm.deleteDiceRoll(obj: roll)
                print("pressed")
            }, label: {
                Text("Add")
            })
            .frame(height: 55).frame(maxWidth: 90)
            .foregroundColor(Color.white).background(Color.blue)
            .cornerRadius(10)
            .padding(.trailing)
        }
    }

    var body : some View {
        TabView {
            let personIcon = vm.characterCount < 2 ? "person" : (vm.characterCount > 2 ? "person.3" : "person.2")

            CharacterPage
                .tabItem {Label("Characters", systemImage: personIcon)}

            DiceRollerPage
                .tabItem {Label("Dice Roller", systemImage: "dice")}
        }
        .tint(Color.purple)
    }
}

#Preview {
    CoreDataViewModelDebugView()
}

