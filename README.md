# Diário

[![iOS](https://img.shields.io/badge/iOS-26.1%2B-000000?logo=apple)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.9-F05138?logo=swift&logoColor=white)](https://swift.org)
[![Apple Intelligence](https://img.shields.io/badge/Foundation%20Models-on--device%20AI-8E44AD)](https://developer.apple.com/documentation/foundationmodels)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

A personal journal for iOS with an on-device AI weekly summary, Shortcuts support and playful animations.

<p align="center">
  <img src="_Screenshots/demo.gif" width="250" alt="Diário demo">
</p>

## Table of Contents

- [About](#about)
- [Features](#features)
- [Screenshots](#screenshots)
- [Built With](#built-with)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Author](#author)
- [License](#license)

## About

Diário is a small SwiftUI journal built to explore three recent Apple frameworks in
one app: **Foundation Models** for on-device text generation, **App Intents** for
Shortcuts and Siri, and SwiftUI's newer animation APIs. The UI is in Portuguese.

## Features

- Create, edit and delete entries with a title, text and mood
- Animated mood picker
- Weekly summary generated on device with Apple Intelligence
- Shortcuts actions to create an entry and read the latest one
- Confetti and toast feedback when an entry is saved

## Screenshots

| Empty state | New entry | Entries | AI summary |
| :---: | :---: | :---: | :---: |
| <img src="_Screenshots/empty.png" width="180"> | <img src="_Screenshots/new_entry.png" width="180"> | <img src="_Screenshots/home.png" width="180"> | <img src="_Screenshots/summary.png" width="180"> |

## Built With

- SwiftUI with MVVM
- [Foundation Models](https://developer.apple.com/documentation/foundationmodels): `LanguageModelSession` with a `@Generable` `WeeklySummary` type for structured output
- [App Intents](https://developer.apple.com/documentation/appintents): `CreateDiaryEntryIntent` and `GetLastEntryIntent`
- Native animations: `.bouncy`, `.smooth`, `.snappy` and `symbolEffect`
- [ConfettiSwiftUI](https://github.com/simibac/ConfettiSwiftUI) (Swift Package)

## Getting Started

Requirements: Xcode 26 or later. The AI summary needs a device or simulator with
Apple Intelligence enabled; the rest of the app works without it.

```bash
git clone https://github.com/EnzoFerroni/Diario.git
cd Diario
open Diario.xcodeproj
```

Xcode resolves the ConfettiSwiftUI package on first build.

## Project Structure

```
Diario/
├── DiarioApp.swift
├── Models/        DiaryEntry, Mood
├── ViewModels/    DiaryViewModel
├── Views/         DiaryListView, DiaryEntryView, NewEntryView
├── Services/      AIService (Foundation Models)
└── Intents/       DiaryAppIntents (Shortcuts)
```

## Author

<div align="center">
  <table>
    <tr>
      <td align="center" width="100%">
        <a href="https://github.com/EnzoFerroni"><img src="https://github.com/EnzoFerroni.png" width="90" alt="Enzo Ferroni"/></a>
        <br/><sub><b>Enzo Ferroni</b></sub><br/><br/>
        <a href="https://github.com/EnzoFerroni"><img src="https://skillicons.dev/icons?i=github" alt="GitHub"/></a>
        <a href="https://www.linkedin.com/in/enzoferroni/"><img src="https://skillicons.dev/icons?i=linkedin" alt="LinkedIn"/></a>
      </td>
    </tr>
  </table>
</div>

## License

Released under the [MIT License](LICENSE). Copyright (c) 2025 Enzo Ferroni.
