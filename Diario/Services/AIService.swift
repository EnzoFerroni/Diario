import SwiftUI

#if canImport(FoundationModels)
import FoundationModels

@Generable(description: "Resumo semanal do diário")
struct WeeklySummary {
    @Guide(description: "Resumo em uma frase dos principais acontecimentos")
    var resumo: String
    
    @Guide(description: "Humor predominante da semana")
    var humorPrincipal: String
    
    @Guide(description: "Quantidade de entradas", .range(0...100))
    var totalEntradas: Int
}
#endif

@Observable
class AIService {
    var isProcessing = false
    var isAvailable = false
    
    init() {
        #if canImport(FoundationModels)
        if #available(iOS 26.0, macOS 26.0, *) {
            let model = SystemLanguageModel.default
            if case .available = model.availability {
                isAvailable = true
            }
        }
        #endif
    }
    
    @MainActor
    func generateSummary(for entries: [DiaryEntry]) async -> String {
        if entries.isEmpty { return "Sem entradas para resumir" }
        
        #if canImport(FoundationModels)
        if #available(iOS 26.0, macOS 26.0, *), isAvailable {
            isProcessing = true
            defer { isProcessing = false }
            
            let instructions = """
            Você é um assistente que resume entradas de diário.
            Responda sempre em português brasileiro de forma breve e amigável.
            """
            
            let session = LanguageModelSession(instructions: Instructions(instructions))
            
            let entriesText = entries.prefix(10).map { 
                "\($0.date.formatted(date: .abbreviated, time: .omitted)): \($0.mood.rawValue) \($0.title) - \($0.content)"
            }.joined(separator: "\n")
            
            let prompt = "Resuma essas entradas de diário em 2 frases curtas:\n\(entriesText)"
            
            if let response = try? await session.respond(to: prompt, generating: WeeklySummary.self) {
                let summary = response.content
                return "\(summary.resumo) Humor: \(summary.humorPrincipal) (\(summary.totalEntradas) entradas)"
            }
        }
        #endif
        
        // Fallback local
        let moods = Dictionary(grouping: entries, by: { $0.mood })
        let top = moods.max { $0.value.count < $1.value.count }?.key
        return "Você escreveu \(entries.count) entradas esta semana. Humor principal: \(top?.description ?? "variado")"
    }
}
