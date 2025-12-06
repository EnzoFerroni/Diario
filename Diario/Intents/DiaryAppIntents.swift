//
//  DiaryAppIntents.swift
//  Diario
//
//  Created by Enzo Ferroni on 05/12/25.
//

import AppIntents
import SwiftUI

// MARK: - DiaryEntryEntity

/// Entity representing a diary entry for App Intents
struct DiaryEntryEntity: AppEntity {
    
    var id: UUID
    var title: String
    var content: String
    var moodEmoji: String
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "Diary Entry")
    }
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(moodEmoji) \(title)",
            subtitle: "\(content.prefix(50))..."
        )
    }
    
    static var defaultQuery = DiaryEntryQuery()
}

// MARK: - DiaryEntryQuery

/// Query for fetching diary entries
struct DiaryEntryQuery: EntityQuery {
    
    func entities(for identifiers: [UUID]) async throws -> [DiaryEntryEntity] {
        let viewModel = DiaryViewModel()
        return viewModel.entries
            .filter { identifiers.contains($0.id) }
            .map { entry in
                DiaryEntryEntity(
                    id: entry.id,
                    title: entry.title,
                    content: entry.content,
                    moodEmoji: entry.mood.rawValue
                )
            }
    }
    
    func suggestedEntities() async throws -> [DiaryEntryEntity] {
        let viewModel = DiaryViewModel()
        return viewModel.sortedEntries.prefix(5).map { entry in
            DiaryEntryEntity(
                id: entry.id,
                title: entry.title,
                content: entry.content,
                moodEmoji: entry.mood.rawValue
            )
        }
    }
}

// MARK: - CreateDiaryEntryIntent

/// App Intent to create a new diary entry via Siri or Shortcuts
struct CreateDiaryEntryIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Create Diary Entry"
    static var description = IntentDescription("Creates a new entry in your diary.")
    
    static var openAppWhenRun: Bool = false
    
    @Parameter(title: "Title")
    var entryTitle: String
    
    @Parameter(title: "Content")
    var entryContent: String
    
    @Parameter(title: "Mood", default: .neutral)
    var mood: MoodOption
    
    static var parameterSummary: some ParameterSummary {
        Summary("Create diary entry titled \(\.$entryTitle)") {
            \.$entryContent
            \.$mood
        }
    }
    
    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let viewModel = DiaryViewModel()
        
        viewModel.addEntry(
            title: entryTitle,
            content: entryContent,
            mood: mood.toMood()
        )
        
        return .result(
            dialog: "Done! I've added '\(entryTitle)' to your diary."
        )
    }
}

// MARK: - MoodOption

/// Mood options for App Intents parameter
enum MoodOption: String, AppEnum {
    case happy
    case neutral
    case sad
    case excited
    case anxious
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "Mood")
    }
    
    static var caseDisplayRepresentations: [MoodOption: DisplayRepresentation] {
        [
            .happy: DisplayRepresentation(title: "Happy 😊"),
            .neutral: DisplayRepresentation(title: "Neutral 😐"),
            .sad: DisplayRepresentation(title: "Sad 😢"),
            .excited: DisplayRepresentation(title: "Excited 🎉"),
            .anxious: DisplayRepresentation(title: "Anxious 😰")
        ]
    }
    
    /// Converts MoodOption to Mood model
    func toMood() -> Mood {
        switch self {
        case .happy: return .happy
        case .neutral: return .neutral
        case .sad: return .sad
        case .excited: return .excited
        case .anxious: return .anxious
        }
    }
}

// MARK: - GetLastEntryIntent

/// App Intent to get the last diary entry
struct GetLastEntryIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Get Last Diary Entry"
    static var description = IntentDescription("Reads your most recent diary entry.")
    
    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let viewModel = DiaryViewModel()
        
        guard let lastEntry = viewModel.sortedEntries.first else {
            return .result(dialog: "You don't have any diary entries yet.")
        }
        
        let formattedDate = lastEntry.date.formatted(date: .abbreviated, time: .omitted)
        
        return .result(
            dialog: """
            Your last entry from \(formattedDate) titled '\(lastEntry.title)': \
            \(lastEntry.content)
            """
        )
    }
}

// MARK: - DiaryShortcuts

/// Provides App Shortcuts for the diary app
struct DiaryShortcuts: AppShortcutsProvider {
    
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: CreateDiaryEntryIntent(),
            phrases: [
                "Create a diary entry in \(.applicationName)",
                "Add to my diary in \(.applicationName)",
                "Write in \(.applicationName)"
            ],
            shortTitle: "New Entry",
            systemImageName: "square.and.pencil"
        )
        
        AppShortcut(
            intent: GetLastEntryIntent(),
            phrases: [
                "Read my last diary entry in \(.applicationName)",
                "What did I write in \(.applicationName)"
            ],
            shortTitle: "Last Entry",
            systemImageName: "book"
        )
    }
}
