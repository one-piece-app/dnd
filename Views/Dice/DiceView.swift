//
//  DiceView.swift
//  DNDCompanion
//
//  Created by Ivanov Garcia on 2/25/26.
// modified by jagadeesh on 4/16/26
import SwiftUI
import UIKit

struct DiceView: View {
    @EnvironmentObject var vm: CoreDataViewModel

    @State private var selectedDice = 20
    @State private var quantity = 1
    @State private var modifier = 0
    @State private var displayedNumber = 1
    @State private var isRolling = false
    @State private var scale: CGFloat = 1.0

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Dice Roller")
                    .font(.title2.weight(.semibold))
                    .foregroundColor(Theme.textPrimary)

                ZStack {
                    Circle()
                        .fill(Theme.accent.opacity(0.12))
                        .frame(width: 180, height: 180)

                    Circle()
                        .fill(Theme.card)
                        .frame(width: 140, height: 140)
                        .overlay(
                            Circle()
                                .stroke(Theme.gold.opacity(0.25), lineWidth: 1)
                        )

                    VStack(spacing: 6) {
                        Image(systemName: "die.face.5.fill")
                            .font(.title2)
                            .foregroundColor(Theme.gold.opacity(0.85))

                        Text("\(displayedNumber)")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(Theme.gold)
                            .scaleEffect(scale)
                            .animation(.easeInOut(duration: 0.15), value: scale)
                    }
                }

                Picker("Dice", selection: $selectedDice) {
                    ForEach([4, 6, 8, 10, 12, 20, 100], id: \.self) { value in
                        Text("d\(value)").tag(value)
                    }
                }
                .pickerStyle(.segmented)

                VStack(spacing: 12) {
                    settingRow(title: "Quantity", value: "\(quantity)") {
                        Stepper("", value: $quantity, in: 1...10)
                            .labelsHidden()
                    }

                    settingRow(title: "Modifier", value: "\(modifier)") {
                        Stepper("", value: $modifier, in: -10...20)
                            .labelsHidden()
                    }
                }
                .padding()
                .background(Theme.card)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Theme.gold.opacity(0.08), lineWidth: 1)
                )

                Button(action: rollDiceAnimated) {
                    Text(isRolling ? "Rolling..." : "Roll")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .disabled(isRolling)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Roll History")
                        .font(.headline)
                        .foregroundColor(Theme.textPrimary)

                    if vm.rollHistory.isEmpty {
                        HStack(spacing: 10) {
                            Image(systemName: "clock.arrow.circlepath")
                                .foregroundColor(Theme.gold)

                            Text("No rolls yet")
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Theme.card)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    } else {
                        ForEach(vm.rollHistory, id: \.objectID) { roll in
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "die.face.5.fill")
                                    .foregroundColor(Theme.gold)
                                    .padding(.top, 2)

                                VStack(alignment: .leading, spacing: 6) {
                                    Text("\(roll.quantity)d\(roll.diceType) + \(roll.modifier)")
                                        .font(.subheadline.weight(.medium))
                                        .foregroundColor(Theme.textPrimary)

                                    Text("Results: \(roll.resultsList().map { String($0) }.joined(separator: ", "))")
                                        .font(.subheadline)
                                        .foregroundColor(Theme.textSecondary)

                                    Text("Total: \(roll.total)")
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundColor(Theme.textPrimary)
                                }

                                Spacer()
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Theme.card)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(Theme.gold.opacity(0.08), lineWidth: 1)
                            )
                        }
                    }
                }
            }
            .padding(20)
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("Dice")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func settingRow<Content: View>(
        title: String,
        value: String,
        @ViewBuilder control: () -> Content
    ) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(Theme.textSecondary)

                Text(value)
                    .font(.headline)
                    .foregroundColor(Theme.textPrimary)
            }

            Spacer()

            control()
        }
    }

    private func rollDiceAnimated() {
        isRolling = true

        let rollDuration = 1.0
        let interval = 0.05
        let steps = Int(rollDuration / interval)
        var currentStep = 0

        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            displayedNumber = Int.random(in: 1...selectedDice)
            scale = 1.15

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                scale = 1.0
            }

            currentStep += 1

            if currentStep >= steps {
                timer.invalidate()

                var results: [Int] = []
                for _ in 0..<quantity {
                    results.append(Int.random(in: 1...selectedDice))
                }

                let total = results.reduce(0, +) + modifier
                displayedNumber = total

                vm.addDiceRoll(
                    diceType: selectedDice,
                    quantity: quantity,
                    modifier: modifier,
                    results: results,
                    total: total
                )

                isRolling = false
            }
        }
    }
}
