# Diario

App de diário pessoal feito em SwiftUI.

## Funcionalidades

- Criar, editar e excluir entradas
- Selecionar humor (feliz, triste, animado, ansioso, neutro)
- Resumo semanal com inteligência artificial
- Animações e feedback visual

## Tecnologias Utilizadas

### AppIntents

Permite usar o app através do app **Atalhos** :
- `CreateDiaryEntryIntent` → Cria nova entrada
- `GetLastEntryIntent` → Mostra última entrada

### FoundationModels

Usa a **Apple Intelligence** para gerar resumos:
- `@Generable` com `WeeklySummary` para respostas estruturadas
- Verifica se IA está disponível no dispositivo
- Fallback local quando IA não está disponível

### Animações

| Animação | Onde | Descrição |
|----------|------|-----------|
| Confetti | Ao salvar entrada | Biblioteca ConfettiSwiftUI |
| Toast | Feedback de sucesso | Aparece no topo da tela |
| Bounce | Seleção de humor | Emoji aumenta e rotaciona |
| Shake | Campos vazios | Tremida no formulário |
| Success | Ao salvar | Overlay com checkmark |

Animações nativas: `.bouncy`, `.smooth`, `.snappy`, `symbolEffect(.bounce)`

### Pacotes SPM

- [ConfettiSwiftUI](https://github.com/simibac/ConfettiSwiftUI) - Efeito de confetti
