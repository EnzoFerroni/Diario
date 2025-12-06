//
//  DiaryListView.swift
//  Diario
//
//  Created by Enzo Ferroni on 05/12/25.
//

import SwiftUI

// MARK: - DiaryListView

/// Main view displaying the list of diary entries with subtle animations
struct DiaryListView: View {
    
    // MARK: - Environment & State
    
    @State private var viewModel: DiaryViewModel
    @State private var aiService: AIService
    @State private var showingNewEntry = false
    @State private var selectedEntry: DiaryEntry?
    @State private var showingSummary = false
    @State private var summaryText: String = ""
    
    // MARK: - Initialization
    
    init(viewModel: DiaryViewModel = DiaryViewModel(), aiService: AIService = AIService()) {
        _viewModel = State(initialValue: viewModel)
        _aiService = State(initialValue: aiService)
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.entries.isEmpty {
                    emptyStateView
                }
                else {
                    entriesListView
                }
            }
            .navigationTitle("My Diary")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    addButton
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    summaryButton
                }
            }
            .sheet(isPresented: $showingNewEntry) {
                NewEntryView(viewModel: viewModel)
            }
            .sheet(item: $selectedEntry) { entry in
                DiaryEntryView(entry: entry, viewModel: viewModel)
            }
            .alert("Weekly Summary", isPresented: $showingSummary) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(summaryText)
            }
        }
    }
    
    // MARK: - Subviews
    
    /// Empty state view when no entries exist
    private var emptyStateView: some View {
        ContentUnavailableView {
            Label("No Entries", systemImage: "book.closed")
        } description: {
            Text("Start writing your thoughts by tapping the + button.")
        } actions: {
            Button("Add Entry") {
                showingNewEntry = true
            }
            .buttonStyle(.borderedProminent)
        }
        .transition(.opacity.combined(with: .scale))
    }
    
    /// List view displaying all diary entries
    private var entriesListView: some View {
        List {
            ForEach(viewModel.sortedEntries) { entry in
                DiaryEntryRow(entry: entry)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedEntry = entry
                        }
                    }
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .slide.combined(with: .opacity)
                    ))
            }
            .onDelete(perform: viewModel.deleteEntries)
        }
        .listStyle(.insetGrouped)
        .animation(.easeInOut(duration: 0.3), value: viewModel.entries)
    }
    
    /// Button to add new entry
    private var addButton: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                showingNewEntry = true
            }
        } label: {
            Image(systemName: "plus.circle.fill")
                .font(.title2)
                .symbolEffect(.bounce, value: showingNewEntry)
        }
    }
    
    /// Button to generate AI summary
    private var summaryButton: some View {
        Button {
            Task {
                await generateSummary()
            }
        } label: {
            if aiService.isProcessing {
                ProgressView()
                    .scaleEffect(0.8)
            }
            else {
                Image(systemName: "sparkles")
                    .symbolEffect(.pulse, isActive: aiService.isProcessing)
            }
        }
        .disabled(viewModel.entries.isEmpty || aiService.isProcessing)
    }
    
    // MARK: - Private Methods
    
    /// Generates an AI summary of weekly entries
    private func generateSummary() async {
        let weeklyEntries = viewModel.weeklyEntries
        
        guard !weeklyEntries.isEmpty else {
            summaryText = "No entries this week to summarize."
            showingSummary = true
            return
        }
        
        if let summary = await aiService.generateSummary(for: weeklyEntries) {
            summaryText = summary
        }
        else {
            summaryText = "Could not generate summary."
        }
        
        withAnimation(.easeInOut(duration: 0.2)) {
            showingSummary = true
        }
    }
}

// MARK: - DiaryEntryRow

/// A single row displaying a diary entry preview
struct DiaryEntryRow: View {
    let entry: DiaryEntry
    
    var body: some View {
        HStack(spacing: 12) {
            // Mood indicator
            Text(entry.mood.rawValue)
                .font(.title)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.title)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(entry.content)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                
                Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview

#Preview {
    DiaryListView(
        viewModel: {
            let vm = DiaryViewModel()
            vm.entries = DiaryEntry.sampleEntries
            return vm
        }()
    )
}
