//
//  HomeView.swift
//  DNDCompanion
//
//  Created by Ivanov Garcia on 2/25/26.
//  UI modified by Jagadeesh on 04/15/26

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var vm: CoreDataViewModel
    @State private var showSettings = false

    let character: CharacterEntity

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                heroCard

                VStack(alignment: .leading, spacing: 12) {
                    Text("Quick Access")
                        .font(.headline)
                        .foregroundColor(Theme.textSecondary)

                    LazyVGrid(columns: columns, spacing: 16) {
                        dashboardLink(
                            title: "Dice Roller",
                            subtitle: "Roll any die",
                            systemImage: "die.face.5.fill",
                            destination: DiceView()
                        )

                        dashboardLink(
                            title: "Character Sheet",
                            subtitle: "Stats & spells",
                            systemImage: "person.text.rectangle.fill",
                            destination: CharacterDetailView(character: character)
                        )

                        dashboardLink(
                            title: "Notes",
                            subtitle: "Sessions & quests",
                            systemImage: "book.closed.fill",
                            destination: NotesListView()
                        )

                        settingsCard
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Character Snapshot")
                        .font(.headline)
                        .foregroundColor(Theme.textSecondary)

                    HStack(spacing: 12) {
                        statPill(title: "Level", value: "\(character.level)")
                        statPill(title: "Race", value: character.race ?? "Unknown")
                        statPill(title: "Class", value: character.characterClass ?? "Unknown")
                    }
                }
            }
            .padding(20)
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("D&D Companion")
                    .font(.headline)
                    .foregroundColor(Theme.textPrimary)
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }

    private var heroCard: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Theme.card,
                            Theme.card.opacity(0.95),
                            Theme.accent.opacity(0.35)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(Theme.gold.opacity(0.28), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.35), radius: 14, x: 0, y: 10)

            VStack(alignment: .leading, spacing: 18) {
                HStack(alignment: .center, spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(Theme.gold.opacity(0.16))
                            .frame(width: 62, height: 62)

                        Image(systemName: "shield.lefthalf.filled")
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundColor(Theme.gold)
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text(character.name ?? "Unnamed Hero")
                            .font(.system(size: 28, weight: .bold))

                        Text("\(character.race ?? "Unknown") • \(character.characterClass ?? "Unknown")")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                    }

                    Spacer()
                }

                HStack(spacing: 12) {
                    heroBadge(title: "Level", value: "\(character.level)")
                    heroBadge(title: "Status", value: "Ready")
                }
            }
            .padding(22)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 190)
    }

    private var settingsCard: some View {
        Button {
            showSettings = true
        } label: {
            dashboardCardContent(
                title: "Settings",
                subtitle: "Preferences",
                systemImage: "gearshape.fill"
            )
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func dashboardLink<Destination: View>(
        title: String,
        subtitle: String,
        systemImage: String,
        destination: Destination
    ) -> some View {
        NavigationLink(destination: destination) {
            dashboardCardContent(
                title: title,
                subtitle: subtitle,
                systemImage: systemImage
            )
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func dashboardCardContent(
        title: String,
        subtitle: String,
        systemImage: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Theme.gold.opacity(0.14))
                    .frame(width: 48, height: 48)

                Image(systemName: systemImage)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Theme.gold)
            }

            Spacer(minLength: 6)

            Text(title)
                .font(.headline)
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.leading)

            Text(subtitle)
                .font(.caption)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, minHeight: 150, alignment: .topLeading)
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Theme.card)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Theme.gold.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.22), radius: 10, x: 0, y: 6)
    }

    private func heroBadge(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased())
                .font(.caption2)
                .foregroundColor(Theme.textSecondary)

            Text(value)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(Theme.textPrimary)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Theme.background.opacity(0.55))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private func statPill(title: String, value: String) -> some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(Theme.textSecondary)

            Text(value)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(Theme.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Theme.card)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Theme.gold.opacity(0.10), lineWidth: 1)
        )
    }
}
