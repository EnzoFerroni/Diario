//
//  NewEntryView.swift
//  Diario
//
//  Created by Enzo Ferroni on 05/12/25.
//

import SwiftUI

// MARK: - NewEntryView

/// View for creating a new diary entry with mood selection and subtle animations
struct NewEntryView: View {
    
    // MARK: - Environment & State
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var selectedMood: Mood = .neutral
    @State private var isAnimating = false
    
    // MARK: - Properties
    
    var viewModel: DiaryViewModel
    
    // MARK: - Computed Properties
    
    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            Form {
                titleSection
                moodSection
                contentSection
            }
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    saveButton
                }
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.3)) {
                    isAnimating = true
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    /// Title input section
    private var titleSection: some View {
        Section {
            TextField("Entry title", text: $title)
                .font(.headline)
        } header: {
            Text("Title")
        }
        .opacity(isAnimating ? 1 : 0)
        .offset(y: isAnimating ? 0 : 10)
    }
    
    /// Mood selection section with animated picker
    private var moodSection: some View {
        Section {
            HStack(spacing: 16) {
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
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 8)
        } header: {
            Text("How are you feeling?")
        }
        .opacity(isAnimating ? 1 : 0)
        .offset(y: isAnimating ? 0 : 10)
        .animation(.easeOut(duration: 0.3).delay(0.1), value: isAnimating)
    }
    
    /// Content input section
    private var contentSection: some View {
        Section {
            TextEditor(text: $content)
                .frame(minHeight: 150)
        } header: {
            Text("What's on your mind?")
        }
        .opacity(isAnimating ? 1 : 0)
        .offset(y: isAnimating ? 0 : 10)
        .animation(.easeOut(duration: 0.3).delay(0.2), value: isAnimating)
    }
    
    /// Save button with validation
    private var saveButton: some View {
        Button("Save") {
            saveEntry()
        }
        .fontWeight(.semibold)
        .disabled(!canSave)
    }
    
    // MARK: - Private Methods
    
    /// Saves the new entry and dismisses the view
    private func saveEntry() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.addEntry(
            title: trimmedTitle,
            content: trimmedContent,
            mood: selectedMood
        )
        
        dismiss()
    }
}

// MARK: - MoodButton

/// A button representing a mood option with selection animation
struct MoodButton: View {
    let mood: Mood
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(mood.rawValue)
                    .font(.largeTitle)
                    .scaleEffect(isSelected ? 1.2 : 1.0)
                
                Text(mood.description)
                    .font(.caption2)
                    .foregroundStyle(isSelected ? .primary : .secondary)
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.accentColor.opacity(0.2) : Color.clear)
            )
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: isSelected)
    }
}

// MARK: - Preview

#Preview {
    NewEntryView(viewModel: DiaryViewModel())
}
