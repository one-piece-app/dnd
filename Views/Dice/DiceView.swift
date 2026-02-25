//
//  DiceView.swift
//  DNDCompanion
//
//  Created by Ivanov Garcia on 2/25/26.
//

import SwiftUI
import SwiftData
import UIKit

struct DiceView: View {
    
    @Environment(\.modelContext) private var context
    @Query(sort: \DiceRoll.timestamp, order: .reverse) var history: [DiceRoll]
    
    @State private var selectedDice = 20
    @State private var quantity = 1
    @State private var modifier = 0
    
    @State private var displayedNumber = 1
    @State private var isRolling = false
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                
                Text("Dice Roller")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                
                // MARK: - Animated Dice Display
                ZStack {
                    Circle()
                        .fill(Theme.card)
                        .frame(width: 150, height: 150)
                        .shadow(radius: 10)
                    
                    Text("\(displayedNumber)")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(Theme.gold)
                        .scaleEffect(scale)
                        .animation(.easeInOut(duration: 0.15), value: scale)
                }
                
                Picker("Dice", selection: $selectedDice) {
                    ForEach([4,6,8,10,12,20,100], id: \.self) {
                        Text("d\($0)").tag($0)
                    }
                }
                .pickerStyle(.segmented)
                
                VStack(spacing: 10) {
                    Stepper("Quantity: \(quantity)", value: $quantity, in: 1...10)
                    Stepper("Modifier: \(modifier)", value: $modifier, in: -10...20)
                }
                .padding()
                .background(Theme.card)
                .cornerRadius(16)
                
                Button(action: rollDiceAnimated) {
                    Text(isRolling ? "ROLLING..." : "ROLL")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.accent)
                        .cornerRadius(16)
                        .foregroundColor(.white)
                }
                .disabled(isRolling)
                
                // MARK: - Roll History
                VStack(alignment: .leading, spacing: 12) {
                    Text("Roll History")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    ForEach(history) { roll in
                        VStack(alignment: .leading) {
                            Text("\(roll.quantity)d\(roll.diceType) + \(roll.modifier)")
                            Text("Results: \(roll.results.map { String($0) }.joined(separator: ", "))")
                            Text("Total: \(roll.total)")
                                .bold()
                        }
                        .padding()
                        .background(Theme.card)
                        .cornerRadius(12)
                    }
                }
            }
            .padding()
        }
        .background(Theme.background.ignoresSafeArea())
    }
}

// MARK: - Animation + Roll Logic
extension DiceView {
    
    func rollDiceAnimated() {
        isRolling = true
        
        let rollDuration = 1.0
        let interval = 0.05
        let steps = Int(rollDuration / interval)
        
        var currentStep = 0
        
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            
            displayedNumber = Int.random(in: 1...selectedDice)
            scale = 1.2
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                scale = 1.0
            }
            
            currentStep += 1
            
            if currentStep >= steps {
                timer.invalidate()
                finishRoll()
            }
        }
    }
    
    func finishRoll() {
        var rolls: [Int] = []
        
        for _ in 0..<quantity {
            rolls.append(Int.random(in: 1...selectedDice))
        }
        
        let total = rolls.reduce(0, +) + modifier
        displayedNumber = total
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        
        let newRoll = DiceRoll(
            diceType: selectedDice,
            quantity: quantity,
            modifier: modifier,
            results: rolls,
            total: total
        )
        
        context.insert(newRoll)
        
        isRolling = false
    }
}
