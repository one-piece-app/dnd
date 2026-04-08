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

    func addCharacter (
        name: String = "john doe",
        characterClass: String,
        race: String,
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

    func deleteCharacter(indexSet: IndexSet) {
        for index in indexSet {
            let characterToDelete = characters[index]
            container.viewContext.delete(characterToDelete)
        }

        for index in indexSet {
            characters.remove(at: index)
        }

        saveContext()
    }

    func addStat(name: String, value: Int16) -> CharacterStatEntity {
        let entity = CharacterStatEntity(context: container.viewContext)
        entity.name = name
        entity.value = value
        return entity
    }
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

extension DiceEntity {
    public func roll() -> Int {
        return roll(sides: Int(sides), quantity: Int(quantity))
    }

    public func roll(sides: Int, quantity: Int = 1) -> Int {
        var sum = 0;
        for _ in 0...Int(quantity) {
            sum = sum + Int.random(in: 1...Int(sides))
        }
        return sum
    }
}

extension NoteEntity {

}

//=~ Debug Preview for CoreData

import SwiftUI

struct CoreDataViewModelDebugView: View {
    @StateObject var vm = CoreDataViewModel()
    @State var userInput: String = ""
    @State var selectedCharacter: CharacterEntity?



    var Characters: some View {
        NavigationView {
            VStack {
                TextField("Character Name", text:$userInput)
                    .padding(.leading)
                    .frame(height: 55)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding()
                Button{
                    guard !userInput.isEmpty else { return }
                    print("pressed")
                    vm.addCharacter(
                        name: userInput,
                        characterClass: "rougue",
                        race: "human",
                        intelligence: 7
                    )
                    userInput = ""

                } label: {
                    Text("Add")
                        .font(Font.headline)
                        .foregroundColor(Color.white)
                        .frame(height:55)
                        .frame(maxWidth: .infinity)
                        .background(Color.purple)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                HStack {
                    List {
                        ForEach(vm.characters, id: \.objectID) { character in
                            Button(
                                action: {
                                    if selectedCharacter == character {
                                        selectedCharacter = nil
                                    } else {
                                        self.selectedCharacter = character
                                    }
                                },
                                label: {
                                    Text("\(character.name ?? "") - \(character.race ?? "") - \(String(character.int?.modifier ?? -99))")
                                        .foregroundColor(Color.white)
                                        .frame(height:40)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.gray)
                                        .cornerRadius(10)
                                }
                            )
                        }
                        .onDelete(perform: vm.deleteCharacter)
                    }
                    .listStyle(PlainListStyle())

                    List {
                        if let character = selectedCharacter, let stats = character.statsList() {
                            ForEach(stats, id: \.objectID) { stat in
                                Text("\(stat.name ?? "unk") - \(String(stat.value)) -  \(String(stat.modifier))")
                            }
                        } else {
                            Text("Select a character to see stats")
                                .foregroundColor(.secondary)
                        }
                    }
                    .listStyle(PlainListStyle())
                    //.listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Character Example")
        }
    }


    var body : some View {
        TabView {
            Characters.tabItem {
                Label("Characters", systemImage: "person.2.fill")
            }
        }
        .tint(Color.purple)
    }
}

#Preview {
    CoreDataViewModelDebugView()
}

