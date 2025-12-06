import SwiftUI
import ConfettiSwiftUI

struct DiaryListView: View {
    @State var viewModel: DiaryViewModel
    @State var aiService: AIService
    @State private var showNew = false
    @State private var selected: DiaryEntry?
    @State private var showSummary = false
    @State private var summary = ""
    @State private var confettiCounter = 0
    @State private var showToast = false
    
    init(viewModel: DiaryViewModel = DiaryViewModel(), aiService: AIService = AIService()) {
        _viewModel = State(initialValue: viewModel)
        _aiService = State(initialValue: aiService)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.entries.isEmpty {
                    ContentUnavailableView("Sem Entradas", systemImage: "book.closed", description: Text("Toque no + para começar"))
                        .transition(.opacity)
                } else {
                    List {
                        ForEach(viewModel.sortedEntries) { entry in
                            EntryRow(entry: entry)
                                .onTapGesture { selected = entry }
                        }
                        .onDelete(perform: viewModel.deleteEntries)
                    }
                    .animation(.smooth, value: viewModel.entries.count)
                }
                
                if showToast {
                    ToastView(message: "Entrada salva! 🎉")
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .confettiCannon(trigger: $confettiCounter, num: 50, colors: [.purple, .pink, .blue, .yellow, .green], confettiSize: 12, rainHeight: 600, radius: 400)
            .navigationTitle("Meu Diário")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showNew = true } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .symbolEffect(.bounce, value: showNew)
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        Task {
                            summary = await aiService.generateSummary(for: viewModel.weeklyEntries)
                            showSummary = true
                        }
                    } label: {
                        if aiService.isProcessing { ProgressView() }
                        else { Image(systemName: "sparkles") }
                    }
                    .disabled(viewModel.entries.isEmpty)
                }
            }
            .sheet(isPresented: $showNew, onDismiss: {
                confettiCounter += 1
                withAnimation(.snappy) { showToast = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation { showToast = false }
                }
            }) {
                NewEntryView(viewModel: viewModel)
            }
            .sheet(item: $selected) { entry in
                DiaryEntryView(entry: entry, viewModel: viewModel)
            }
            .alert("Resumo da Semana ✨", isPresented: $showSummary) {
                Button("Legal!") {}
            } message: {
                Text(summary)
            }
        }
    }
}

struct ToastView: View {
    let message: String
    
    var body: some View {
        VStack {
            Text(message)
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(.ultraThinMaterial, in: Capsule())
                .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
            Spacer()
        }
        .padding(.top, 8)
    }
}

struct EntryRow: View {
    let entry: DiaryEntry
    @State private var show = false
    
    var body: some View {
        HStack(spacing: 12) {
            Text(entry.mood.rawValue)
                .font(.title)
                .scaleEffect(show ? 1 : 0.3)
                .rotationEffect(.degrees(show ? 0 : -30))
            
            VStack(alignment: .leading) {
                Text(entry.title).font(.headline)
                Text(entry.content).font(.subheadline).foregroundStyle(.secondary).lineLimit(2)
                Text(entry.date.formatted(date: .abbreviated, time: .shortened)).font(.caption).foregroundStyle(.tertiary)
            }
            .opacity(show ? 1 : 0)
            .offset(x: show ? 0 : 15)
            
            Spacer()
        }
        .onAppear {
            withAnimation(.bouncy(duration: 0.5)) { show = true }
        }
    }
}

#Preview { DiaryListView() }
