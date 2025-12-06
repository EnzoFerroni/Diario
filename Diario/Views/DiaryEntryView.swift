//
//  DiaryEntryView.swift
//  Diario
//
//  Created by Enzo Ferroni on 05/12/25.
//

import SwiftUI

// MARK: - DiaryEntryView

/// View for displaying and editing an existing diary entry
struct DiaryEntryView: View {
    
    // MARK: - Environment & State
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String
    @State private var content: String
    @State private var selectedMood: Mood
    @State private var isEditing = false
    @State private var showDeleteConfirmation = false
    @State private var contentOpacity: Double = 0
    
    // MARK: - Properties
    
    let entry: DiaryEntry
    var viewModel: DiaryViewModel
    
    // MARK: - Computed Properties
    
    private var hasChanges: Bool {
        title != entry.title ||
        content != entry.content ||
        selectedMood != entry.mood
    }
    
    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: - Initialization
    
    init(entry: DiaryEntry, viewModel: DiaryViewModel) {
        self.entry = entry
        self.viewModel = viewModel
        _title = State(initialValue: entry.title)
        _content = State(initialValue: entry.content)
        _selectedMood = State(initialValue: entry.mood)
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    headerView
                    moodView
                    contentView
                }
                .padding()
            }
            .navigationTitle(isEditing ? "Edit Entry" : "Entry Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(isEditing ? "Cancel" : "Close") {
                        handleCancel()
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    if isEditing {
                        Button("Save") {
                            saveChanges()
                        }
                        .fontWeight(.semibold)
                        .disabled(!canSave || !hasChanges)
                    }
                    else {
                        editButton
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    if !isEditing {
                        deleteButton
                    }
                }
            }
            .confirmationDialog(
                "Delete Entry",
                isPresented: $showDeleteConfirmation,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) {
                    deleteEntry()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to delete this entry? This cannot be undone.")
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.4)) {
                    contentOpacity = 1
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    /// Header with title and date
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            if isEditing {
                TextField("Title", text: $title)
                    .font(.title2.bold())
                    .textFieldStyle(.roundedBorder)
            }
            else {
                Text(title)
                    .font(.title2.bold())
            }
            
            Text(entry.date.formatted(date: .complete, time: .shortened))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .opacity(contentOpacity)
    }
    
    /// Mood display or selector
    private var moodView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Mood")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            if isEditing {
                HStack(spacing: 12) {
                    ForEach(Mood.allCases) { mood in
                        MoodButton(
                            mood: mood,
                            isSelected: selectedMood == mood
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                selectedMood = mood
                            }
                        }
                    }
                }
            }
            else {
                HStack(spacing: 8) {
                    Text(selectedMood.rawValue)
                        .font(.largeTitle)
                    
                    Text(selectedMood.description)
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
        .opacity(contentOpacity)
        .animation(.easeOut(duration: 0.3).delay(0.1), value: contentOpacity)
    }
    
    /// Content display or editor
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Content")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            if isEditing {
                TextEditor(text: $content)
                    .frame(minHeight: 200)
                    .padding(8)
                    .background(Color(.tertiarySystemBackground))
                    .cornerRadius(12)
            }
            else {
                Text(content)
                    .font(.body)
                    .lineSpacing(6)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
        .opacity(contentOpacity)
        .animation(.easeOut(duration: 0.3).delay(0.2), value: contentOpacity)
    }
    
    /// Edit button
    private var editButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                isEditing = true
            }
        } label: {
            Text("Edit")
        }
    }
    
    /// Delete button
    private var deleteButton: some View {
        Button(role: .destructive) {
            showDeleteConfirmation = true
        } label: {
            Label("Delete Entry", systemImage: "trash")
        }
    }
    
    // MARK: - Private Methods
    
    /// Handles cancel action
    private func handleCancel() {
        if isEditing {
            withAnimation(.easeInOut(duration: 0.2)) {
                title = entry.title
                content = entry.content
                selectedMood = entry.mood
                isEditing = false
            }
        }
        else {
            dismiss()
        }
    }
    
    /// Saves changes to the entry
    private func saveChanges() {
        var updatedEntry = entry
        updatedEntry.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedEntry.content = content.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedEntry.mood = selectedMood
        
        viewModel.updateEntry(updatedEntry)
        
        withAnimation(.easeInOut(duration: 0.2)) {
            isEditing = false
        }
    }
    
    /// Deletes the entry
    private func deleteEntry() {
        viewModel.deleteEntry(entry)
        dismiss()
    }
}

// MARK: - Preview

#Preview {
    DiaryEntryView(
        entry: DiaryEntry.sampleEntries[0],
        viewModel: DiaryViewModel()
    )
}
