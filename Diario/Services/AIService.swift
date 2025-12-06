//
//  AIService.swift
//  Diario
//
//  Created by Enzo Ferroni on 05/12/25.
//

import Foundation
import SwiftUI

// MARK: - FoundationModels Import (iOS 26+)

#if canImport(FoundationModels)
import FoundationModels
#endif

// MARK: - AIService

/// Service that provides AI-powered features using Apple's FoundationModels framework
/// Requires iOS 26+ / macOS 26+ for full functionality
@Observable
final class AIService {
    
    // MARK: - Published Properties
    
    var isProcessing: Bool = false
    var lastSummary: String?
    var lastMoodAnalysis: String?
    var errorMessage: String?
    
    // MARK: - Private Properties
    
    #if canImport(FoundationModels)
    private var session: LanguageModelSession?
    #endif
    
    // MARK: - Initialization
    
    init() {
        #if canImport(FoundationModels)
        setupSession()
        #endif
    }
    
    // MARK: - Public Methods
    
    /// Generates a summary of diary entries using Apple Intelligence
    /// - Parameter entries: Array of diary entries to summarize
    /// - Returns: A string summary or nil if unavailable
    @MainActor
    func generateSummary(for entries: [DiaryEntry]) async -> String? {
        guard !entries.isEmpty else {
            return nil
        }
        
        #if canImport(FoundationModels)
        guard isFoundationModelsAvailable() else {
            return generateLocalSummary(for: entries)
        }
        
        isProcessing = true
        defer { isProcessing = false }
        
        do {
            let session = LanguageModelSession()
            
            let entriesText = entries.map { entry in
                "[\(entry.date.formatted(date: .abbreviated, time: .omitted))] " +
                "\(entry.mood.rawValue) \(entry.title): \(entry.content)"
            }.joined(separator: "\n")
            
            let prompt = """
            Summarize these diary entries in 2-3 sentences, highlighting the main \
            themes and emotional patterns:
            
            \(entriesText)
            """
            
            let response = try await session.respond(to: prompt)
            lastSummary = response.content
            return response.content
        }
        catch {
            errorMessage = "AI summary failed: \(error.localizedDescription)"
            return generateLocalSummary(for: entries)
        }
        #else
        return generateLocalSummary(for: entries)
        #endif
    }
    
    /// Analyzes the mood trends from diary entries
    /// - Parameter entries: Array of diary entries to analyze
    /// - Returns: A mood analysis string or nil if unavailable
    @MainActor
    func analyzeMoodTrends(for entries: [DiaryEntry]) async -> String? {
        guard !entries.isEmpty else {
            return nil
        }
        
        #if canImport(FoundationModels)
        guard isFoundationModelsAvailable() else {
            return generateLocalMoodAnalysis(for: entries)
        }
        
        isProcessing = true
        defer { isProcessing = false }
        
        do {
            let session = LanguageModelSession()
            
            let moodList = entries.map { "\($0.mood.description)" }.joined(separator: ", ")
            
            let prompt = """
            Based on these mood entries over time, provide a brief emotional \
            insight in 1-2 sentences: \(moodList)
            """
            
            let response = try await session.respond(to: prompt)
            lastMoodAnalysis = response.content
            return response.content
        }
        catch {
            errorMessage = "Mood analysis failed: \(error.localizedDescription)"
            return generateLocalMoodAnalysis(for: entries)
        }
        #else
        return generateLocalMoodAnalysis(for: entries)
        #endif
    }
    
    /// Checks if FoundationModels is available on the current device
    /// - Returns: True if AI features are available
    func isFoundationModelsAvailable() -> Bool {
        #if canImport(FoundationModels)
        if #available(iOS 26.0, macOS 26.0, *) {
            return true
        }
        #endif
        return false
    }
    
    // MARK: - Private Methods
    
    #if canImport(FoundationModels)
    private func setupSession() {
        if #available(iOS 26.0, macOS 26.0, *) {
            session = LanguageModelSession()
        }
    }
    #endif
    
    /// Generates a local summary without AI when FoundationModels is unavailable
    private func generateLocalSummary(for entries: [DiaryEntry]) -> String {
        let moodCounts = Dictionary(grouping: entries, by: { $0.mood })
        let dominantMood = moodCounts.max(by: { $0.value.count < $1.value.count })?.key
        
        let summary = "You wrote \(entries.count) entries. " +
            "Your predominant mood was \(dominantMood?.description ?? "varied")."
        
        lastSummary = summary
        return summary
    }
    
    /// Generates local mood analysis without AI
    private func generateLocalMoodAnalysis(for entries: [DiaryEntry]) -> String {
        let moodCounts = Dictionary(grouping: entries, by: { $0.mood })
        let sortedMoods = moodCounts.sorted { $0.value.count > $1.value.count }
        
        guard let topMood = sortedMoods.first else {
            return "No mood data available."
        }
        
        let percentage = Int((Double(topMood.value.count) / Double(entries.count)) * 100)
        let analysis = "You felt \(topMood.key.description.lowercased()) " +
            "\(percentage)% of the time."
        
        lastMoodAnalysis = analysis
        return analysis
    }
}
