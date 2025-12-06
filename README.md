# 📔 Diario

App de diário pessoal feito em SwiftUI para a Apple Developer Academy | Mackenzie.

## Funcionalidades

- ✏️ Criar, editar e excluir entradas
- 😊 Selecionar humor (feliz, triste, animado, ansioso, neutro)
- ✨ Resumo semanal com inteligência artificial
- 🎉 Animações e feedback visual

## Tecnologias Utilizadas

### 📱 AppIntents
`Intents/DiaryAppIntents.swift`

Permite usar o app através do app **Atalhos** do iOS:
- `CreateDiaryEntryIntent` → Cria nova entrada
- `GetLastEntryIntent` → Mostra última entrada

### 🤖 FoundationModels
`Services/AIService.swift`

Usa a **Apple Intelligence** (iOS 26+) para gerar resumos:
- `@Generable` com `WeeklySummary` para respostas estruturadas
- Verifica se IA está disponível no dispositivo
- Fallback local quando IA não está disponível

### 🎨 Animações
`Views/`

| Animação | Onde | Descrição |
|----------|------|-----------|
| Confetti | Ao salvar entrada | Biblioteca ConfettiSwiftUI |
| Toast | Feedback de sucesso | Aparece no topo da tela |
| Bounce | Seleção de humor | Emoji aumenta e rotaciona |
| Shake | Campos vazios | Tremida no formulário |
| Success | Ao salvar | Overlay com checkmark |

Animações nativas: `.bouncy`, `.smooth`, `.snappy`, `symbolEffect(.bounce)`

### 📦 Pacotes SPM

- [ConfettiSwiftUI](https://github.com/simibac/ConfettiSwiftUI) - Efeito de confetti

## Arquitetura MVVM

```
Diario/
├── Models/
│   └── DiaryEntry.swift      # Modelo de entrada e enum Mood
├── ViewModels/
│   └── DiaryViewModel.swift  # Lógica e persistência (UserDefaults)
├── Views/
│   ├── DiaryListView.swift   # Tela principal com lista
│   ├── NewEntryView.swift    # Criar nova entrada
│   └── DiaryEntryView.swift  # Ver/editar entrada
├── Services/
│   └── AIService.swift       # Integração com FoundationModels
└── Intents/
    └── DiaryAppIntents.swift # AppIntents para Atalhos
```
