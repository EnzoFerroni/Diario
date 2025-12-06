import SwiftUI

@Observable
class DiaryViewModel {
    var entries: [DiaryEntry] = []
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "entries") {
            entries = (try? JSONDecoder().decode([DiaryEntry].self, from: data)) ?? []
        }
    }
    
    func addEntry(title: String, content: String, mood: Mood) {
        let entry = DiaryEntry(title: title, content: content, mood: mood)
        withAnimation { entries.insert(entry, at: 0) }
        save()
    }
    
    func updateEntry(_ entry: DiaryEntry) {
        if let i = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[i] = entry
            save()
        }
    }
    
    func deleteEntries(at offsets: IndexSet) {
        withAnimation { entries.remove(atOffsets: offsets) }
        save()
    }
    
    func deleteEntry(_ entry: DiaryEntry) {
        withAnimation { entries.removeAll { $0.id == entry.id } }
        save()
    }
    
    var sortedEntries: [DiaryEntry] {
        entries.sorted { $0.date > $1.date }
    }
    
    var weeklyEntries: [DiaryEntry] {
        let week = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        return entries.filter { $0.date >= week }
    }
    
    private func save() {
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: "entries")
        }
    }
}
