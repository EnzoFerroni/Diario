import SwiftUI

struct DiaryEntryView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title: String
    @State private var content: String
    @State private var mood: Mood
    @State private var editing = false
    @State private var showDelete = false
    @State private var show = false
    
    let entry: DiaryEntry
    var viewModel: DiaryViewModel
    
    init(entry: DiaryEntry, viewModel: DiaryViewModel) {
        self.entry = entry
        self.viewModel = viewModel
        _title = State(initialValue: entry.title)
        _content = State(initialValue: entry.content)
        _mood = State(initialValue: entry.mood)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    headerSection
                    moodSection
                    contentSection
                }
                .padding()
                .opacity(show ? 1 : 0)
                .offset(y: show ? 0 : 20)
            }
            .navigationTitle(editing ? "Editar" : "Detalhes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(editing ? "Cancelar" : "Fechar") {
                        if editing {
                            withAnimation(.snappy) {
                                title = entry.title
                                content = entry.content
                                mood = entry.mood
                                editing = false
                            }
                        } else { dismiss() }
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    if editing {
                        Button("Salvar") {
                            var e = entry
                            e.title = title
                            e.content = content
                            e.mood = mood
                            viewModel.updateEntry(e)
                            withAnimation(.snappy) { editing = false }
                        }
                    } else {
                        Button("Editar") {
                            withAnimation(.snappy) { editing = true }
                        }
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    if !editing {
                        Button(role: .destructive) { showDelete = true } label: {
                            Label("Excluir", systemImage: "trash")
                        }
                    }
                }
            }
            .alert("Excluir?", isPresented: $showDelete) {
                Button("Excluir", role: .destructive) {
                    viewModel.deleteEntry(entry)
                    dismiss()
                }
                Button("Cancelar", role: .cancel) {}
            }
            .onAppear {
                withAnimation(.smooth(duration: 0.4)) { show = true }
            }
        }
    }
    
    var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            if editing {
                TextField("Título", text: $title)
                    .font(.title2.bold())
                    .textFieldStyle(.roundedBorder)
                    .transition(.scale)
            } else {
                Text(title).font(.title2.bold())
            }
            Text(entry.date.formatted(date: .complete, time: .shortened))
                .foregroundStyle(.secondary)
        }
    }
    
    var moodSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Humor").font(.headline).foregroundStyle(.secondary)
            if editing {
                HStack(spacing: 8) {
                    ForEach(Mood.allCases) { m in
                        Button {
                            withAnimation(.bouncy) { mood = m }
                        } label: {
                            Text(m.rawValue)
                                .font(.title)
                                .scaleEffect(mood == m ? 1.2 : 1)
                                .rotationEffect(.degrees(mood == m ? 10 : 0))
                        }
                        .buttonStyle(.plain)
                    }
                }
            } else {
                HStack(spacing: 6) {
                    Text(mood.rawValue).font(.largeTitle)
                    Text(mood.description)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 14))
    }
    
    var contentSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Conteúdo").font(.headline).foregroundStyle(.secondary)
            if editing {
                TextEditor(text: $content)
                    .frame(minHeight: 150)
                    .scrollContentBackground(.hidden)
            } else {
                Text(content).lineSpacing(5)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 14))
    }
}

#Preview { DiaryEntryView(entry: DiaryEntry.samples[0], viewModel: DiaryViewModel()) }
