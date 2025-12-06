import Foundation

enum Mood: String, Codable, CaseIterable, Identifiable {
    case happy = "😊"
    case neutral = "😐"
    case sad = "😢"
    case excited = "🎉"
    case anxious = "😰"
    
    var id: String { rawValue }
    
    var description: String {
        switch self {
        case .happy: return "Feliz"
        case .neutral: return "Neutro"
        case .sad: return "Triste"
        case .excited: return "Animado"
        case .anxious: return "Ansioso"
        }
    }
}

struct DiaryEntry: Identifiable, Codable, Hashable {
    var id = UUID()
    var title: String
    var content: String
    var date = Date()
    var mood: Mood = .neutral
}

extension DiaryEntry {
    static let samples = [
        DiaryEntry(title: "Primeiro Dia", content: "Comecei a usar o app!", mood: .happy),
        DiaryEntry(title: "Dia Legal", content: "Foi um bom dia.", mood: .excited)
    ]
}
