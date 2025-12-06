import SwiftUI

struct NewEntryView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var content = ""
    @State private var mood: Mood = .neutral
    @State private var animate = false
    @State private var saved = false
    @State private var shake = false
    
    var viewModel: DiaryViewModel
    
    var canSave: Bool { !title.isEmpty && !content.isEmpty }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Título") {
                    TextField("Título", text: $title)
                        .modifier(ShakeEffect(shakes: shake ? 2 : 0))
                }
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : 15)
                
                Section("Como você está?") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(Mood.allCases) { m in
                                MoodButton(mood: m, selected: mood == m) {
                                    withAnimation(.bouncy) { mood = m }
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : 15)
                .animation(.smooth.delay(0.1), value: animate)
                
                Section("Conteúdo") {
                    TextEditor(text: $content)
                        .frame(minHeight: 120)
                }
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : 15)
                .animation(.smooth.delay(0.2), value: animate)
            }
            .navigationTitle("Nova Entrada")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") {
                        if canSave {
                            viewModel.addEntry(title: title, content: content, mood: mood)
                            withAnimation(.bouncy) { saved = true }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { dismiss() }
                        } else {
                            withAnimation(.default) { shake = true }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { shake = false }
                        }
                    }
                    .fontWeight(.semibold)
                }
            }
            .onAppear { withAnimation(.smooth) { animate = true } }
            .overlay {
                if saved { SuccessOverlay() }
            }
        }
    }
}

struct MoodButton: View {
    let mood: Mood
    let selected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(mood.rawValue)
                    .font(.system(size: 32))
                    .scaleEffect(selected ? 1.2 : 1)
                    .rotationEffect(.degrees(selected ? 8 : 0))
                Text(mood.description)
                    .font(.caption2)
                    .foregroundStyle(selected ? .primary : .secondary)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(selected ? Color.accentColor.opacity(0.15) : .clear, in: RoundedRectangle(cornerRadius: 12))
            .animation(.bouncy, value: selected)
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: selected)
    }
}

struct SuccessOverlay: View {
    @State private var scale = 0.5
    @State private var checkScale = 0.0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.2).ignoresSafeArea()
            
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(.green.gradient)
                        .frame(width: 70, height: 70)
                        .scaleEffect(scale)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.white)
                        .scaleEffect(checkScale)
                }
                
                Text("Salvo!")
                    .font(.headline)
                    .opacity(checkScale)
            }
            .padding(30)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
            .scaleEffect(scale)
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) { scale = 1 }
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5).delay(0.15)) { checkScale = 1 }
        }
    }
}

struct ShakeEffect: GeometryEffect {
    var shakes: CGFloat
    var animatableData: CGFloat {
        get { shakes }
        set { shakes = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: sin(shakes * .pi * 2) * 5, y: 0))
    }
}

#Preview { NewEntryView(viewModel: DiaryViewModel()) }
