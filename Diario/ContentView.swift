//
//  ContentView.swift
//  Diario
//
//  Created by Enzo Ferroni on 05/12/25.
//

import SwiftUI

// MARK: - ContentView

/// Main entry point view that displays the diary list
struct ContentView: View {
    
    // MARK: - State Properties
    
    @State private var viewModel = DiaryViewModel()
    @State private var aiService = AIService()
    
    // MARK: - Body
    
    var body: some View {
        DiaryListView(viewModel: viewModel, aiService: aiService)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
