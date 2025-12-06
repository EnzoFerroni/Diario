import AppIntents

struct CreateDiaryEntryIntent: AppIntent {
    static var title: LocalizedStringResource = "Criar Entrada"
    static var description = IntentDescription("Cria uma nova entrada no diário")
    
    @Parameter(title: "Título")
    var entryTitle: String
    
    @Parameter(title: "Conteúdo")
    var entryContent: String
    
    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let vm = DiaryViewModel()
        vm.addEntry(title: entryTitle, content: entryContent, mood: .neutral)
        return .result(dialog: "Entrada '\(entryTitle)' criada!")
    }
}

struct GetLastEntryIntent: AppIntent {
    static var title: LocalizedStringResource = "Ver Última Entrada"
    static var description = IntentDescription("Mostra a última entrada do diário")
    
    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let vm = DiaryViewModel()
        
        guard let last = vm.sortedEntries.first else {
            return .result(dialog: "Nenhuma entrada encontrada")
        }
        
        return .result(dialog: "\(last.mood.rawValue) \(last.title): \(last.content)")
    }
}

struct DiaryShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: CreateDiaryEntryIntent(),
            phrases: ["Criar entrada no \(.applicationName)"],
            shortTitle: "Nova Entrada",
            systemImageName: "square.and.pencil"
        )
        
        AppShortcut(
            intent: GetLastEntryIntent(),
            phrases: ["Ver entrada no \(.applicationName)"],
            shortTitle: "Última Entrada",
            systemImageName: "book"
        )
    }
}
