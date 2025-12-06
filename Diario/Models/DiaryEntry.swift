//
//  DiaryEntry.swift
//  Diario
//
//  Created by Enzo Ferroni on 05/12/25.
//

import Foundation

// MARK: - Mood Enum

/// Represents the emotional state associated with a diary entry
enum Mood: String, Codable, CaseIterable, Identifiable {
    case happy = "😊"
    case neutral = "😐"
    case sad = "😢"
    case excited = "🎉"
    case anxious = "😰"
    
    var id: String { rawValue }
    
    var description: String {
        switch self {
        case .happy: return "Happy"
        case .neutral: return "Neutral"
        case .sad: return "Sad"
        case .excited: return "Excited"
        case .anxious: return "Anxious"
        }
    }
}

// MARK: - DiaryEntry Model

/// Represents a single diary entry with title, content, date and mood
struct DiaryEntry: Identifiable, Codable, Hashable {
    var id: UUID
    var title: String
    var content: String
    var date: Date
    var mood: Mood
    
    init(
        id: UUID = UUID(),
        title: String,
        content: String,
        date: Date = Date(),
        mood: Mood = .neutral
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.date = date
        self.mood = mood
    }
}

// MARK: - Sample Data

extension DiaryEntry {
    /// Sample entries for previews and testing
    static let sampleEntries: [DiaryEntry] = [
        DiaryEntry(
            title: "First Day",
            content: "Today I started using this diary app. Feeling great!",
            date: Date(),
            mood: .happy
        ),
        DiaryEntry(
            title: "Productive Morning",
            content: "Woke up early and finished all my tasks.",
            date: Date().addingTimeInterval(-86400),
            mood: .excited
        ),
        DiaryEntry(
            title: "Rainy Day",
            content: "Stayed home and read a book. It was peaceful.",
            date: Date().addingTimeInterval(-172800),
            mood: .neutral
        )
    ]
}
