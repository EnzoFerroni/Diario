# 📔 Diario

A simple and elegant diary app built with SwiftUI, featuring AI-powered insights and Siri integration.

## 📱 Overview

Diario is a minimalist diary application that allows users to record their daily thoughts and emotions. The app leverages modern Apple technologies to provide a seamless and intelligent journaling experience.

## 🏗️ Architecture

The project follows the **MVVM (Model-View-ViewModel)** architecture pattern for clean separation of concerns:

```
Diario/
├── Models/
│   └── DiaryEntry.swift        # Data models (DiaryEntry, Mood)
├── ViewModels/
│   └── DiaryViewModel.swift    # Business logic and state management
├── Views/
│   ├── DiaryListView.swift     # Main list of entries
│   ├── DiaryEntryView.swift    # Entry detail/edit view
│   └── NewEntryView.swift      # Create new entry view
├── Services/
│   └── AIService.swift         # FoundationModels integration
├── Intents/
│   └── DiaryAppIntents.swift   # Siri and Shortcuts integration
├── ContentView.swift           # Root view
└── DiarioApp.swift             # App entry point
```

## 🚀 Technologies Applied

### 1. AppIntents (Siri & Shortcuts)

**Location:** `Intents/DiaryAppIntents.swift`

The app integrates with Siri and the Shortcuts app to allow hands-free diary entry creation:

- **CreateDiaryEntryIntent**: Create new entries using voice commands
  - Phrase: *"Create a diary entry in Diario"*
  - Phrase: *"Add to my diary in Diario"*
  
- **GetLastEntryIntent**: Read your most recent entry
  - Phrase: *"Read my last diary entry in Diario"*

- **DiaryShortcuts**: Provides pre-built shortcuts visible in the Shortcuts app

**Implementation Details:**
- Uses `@Parameter` for intent inputs
- Implements `AppEntity` for diary entry representation
- Provides `AppShortcutsProvider` for system integration

### 2. FoundationModels (Apple Intelligence)

**Location:** `Services/AIService.swift`

The app uses Apple's FoundationModels framework (iOS 26+) for AI-powered features:

- **Weekly Summary**: Generates AI-powered summaries of your diary entries
- **Mood Analysis**: Analyzes emotional patterns across entries
- **Fallback Support**: Provides local analysis when AI is unavailable

**Key Features:**
- Uses `LanguageModelSession` for on-device AI processing
- Graceful degradation for older iOS versions
- Privacy-focused: all processing happens on-device

**Usage in App:**
- Tap the ✨ (sparkles) button in the toolbar to generate a weekly summary

### 3. Animations

**Locations:** Throughout `Views/` folder

Subtle, discrete animations enhance the user experience:

| Animation | Location | Purpose |
|-----------|----------|---------|
| List transitions | `DiaryListView.swift` | Smooth entry insertion/removal |
| Mood selection bounce | `NewEntryView.swift`, `DiaryEntryView.swift` | Selection feedback |
| Form appearance | `NewEntryView.swift` | Staggered content reveal |
| Content fade-in | `DiaryEntryView.swift` | Smooth detail loading |
| Button symbol effects | `DiaryListView.swift` | Interactive feedback |

**Animation Principles Applied:**
- ✅ Brief duration (0.2-0.3 seconds)
- ✅ Communicate state changes
- ✅ Provide feedback
- ✅ Avoid disorientation
- ❌ No excessive or distracting animations

## 📋 Features

- ✏️ Create, edit, and delete diary entries
- 😊 Mood tracking with emoji indicators
- 🗓️ Date-organized entries
- 🔍 View entry details
- 🤖 AI-powered weekly summaries
- 🎙️ Siri voice commands
- ⚡ Shortcuts app integration
- 💾 Persistent local storage

## 🛠️ Requirements

- iOS 17.0+ (iOS 26+ for FoundationModels AI features)
- Xcode 15.0+
- Swift 5.9+

## 📦 Installation

1. Clone the repository:
```bash
git clone https://github.com/your-username/Diario.git
```

2. Open `Diario.xcodeproj` in Xcode

3. Build and run on your device or simulator

## 🎯 Usage

### Creating an Entry
1. Tap the **+** button in the top-right corner
2. Enter a title and your thoughts
3. Select your current mood
4. Tap **Save**

### Using Siri
Say: *"Hey Siri, create a diary entry in Diario"*

### Getting AI Summary
1. Tap the **✨** (sparkles) button in the top-left
2. View your weekly mood summary

## 📝 Code Standards

This project follows the [Academy Coding Standards](https://github.com/your-repo/standards):

- English for all code and comments
- camelCase for variables and functions
- PascalCase for types
- K&R brace style
- 4-space indentation
- `guard let` over `if let` for optionals
- Comprehensive documentation with `// MARK:` sections

## 📄 License

This project is developed for educational purposes at Apple Developer Academy | Mackenzie.

---

Made with ❤️ using SwiftUI
