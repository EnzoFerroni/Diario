//
//  DiaryViewModel.swift
//  Diario
//
//  Created by Enzo Ferroni on 05/12/25.
//

import Foundation
import SwiftUI

// MARK: - DiaryViewModel

/// Main ViewModel that manages diary entries with persistence
/// Uses @Observable for automatic SwiftUI updates (iOS 17+)
@Observable
final class DiaryViewModel {
    
    // MARK: - Published Properties
    
    var entries: [DiaryEntry] = []
    var isLoading: Bool = false
    var errorMessage: String?
    
    // MARK: - Private Properties
    
    private let storageKey = "diary_entries"
    
    // MARK: - Initialization
    
    init() {
        loadEntries()
    }
    
    // MARK: - Public Methods
    
    /// Adds a new entry to the diary
    /// - Parameters:
    ///   - title: The entry title
    ///   - content: The entry content
    ///   - mood: The mood associated with the entry
    func addEntry(title: String, content: String, mood: Mood) {
        let newEntry = DiaryEntry(
            title: title,
            content: content,
            mood: mood
        )
        
        withAnimation(.easeInOut(duration: 0.3)) {
            entries.insert(newEntry, at: 0)
        }
        
        saveEntries()
    }
    
    /// Updates an existing entry
    /// - Parameter entry: The updated entry
    func updateEntry(_ entry: DiaryEntry) {
        guard let index = entries.firstIndex(where: { $0.id == entry.id }) else {
            return
        }
        
        withAnimation(.easeInOut(duration: 0.2)) {
            entries[index] = entry
        }
        
        saveEntries()
    }
    
    /// Deletes entries at specified offsets
    /// - Parameter offsets: IndexSet of entries to delete
    func deleteEntries(at offsets: IndexSet) {
        withAnimation(.easeInOut(duration: 0.25)) {
            entries.remove(atOffsets: offsets)
        }
        
        saveEntries()
    }
    
    /// Deletes a specific entry
    /// - Parameter entry: The entry to delete
    func deleteEntry(_ entry: DiaryEntry) {
        withAnimation(.easeInOut(duration: 0.25)) {
            entries.removeAll { $0.id == entry.id }
        }
        
        saveEntries()
    }
    
    /// Returns entries sorted by date (newest first)
    var sortedEntries: [DiaryEntry] {
        entries.sorted { $0.date > $1.date }
    }
    
    /// Returns entries for the current week
    var weeklyEntries: [DiaryEntry] {
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return entries.filter { $0.date >= weekAgo }
    }
    
    // MARK: - Private Methods
    
    /// Loads entries from UserDefaults
    private func loadEntries() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            return
        }
        
        do {
            entries = try JSONDecoder().decode([DiaryEntry].self, from: data)
        }
        catch {
            errorMessage = "Failed to load entries: \(error.localizedDescription)"
        }
    }
    
    /// Saves entries to UserDefaults
    private func saveEntries() {
        do {
            let data = try JSONEncoder().encode(entries)
            UserDefaults.standard.set(data, forKey: storageKey)
        }
        catch {
            errorMessage = "Failed to save entries: \(error.localizedDescription)"
        }
    }
}
