# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

HeatMap is a native iOS/SwiftUI habit-tracking app that displays activity patterns in a GitHub-style heatmap. Users log activities across three categories — **Gym**, **English**, and **Coding** — and see them visualized over the last 10 weeks.

## Build & Test Commands

Build and run via Xcode (open `HeatMap.xcodeproj`), or from the command line:

```bash
# Build
xcodebuild -scheme HeatMap -configuration Debug build

# Run all tests
xcodebuild test -scheme HeatMap -destination 'platform=iOS Simulator,name=iPhone 16'
```

The project has no external dependencies (no CocoaPods, no Swift Package Manager packages).

## Architecture

The app follows **Clean Architecture + MVVM-C**:

```
Application/        → App entry point, DI factories (AppFactory, ScreenFactory)
Domain/             → Protocols and use cases (GetEventsUseCase, AddEventsUseCase)
Data/               → Repository implementations + UserDefaults persistence
Presentation/
  Scenes/Coordinator/  → AppCoordinator (root), MainCoordinatorView (tab nav)
  Scenes/Main/Home/    → HomeCoordinator, HomeView, HomeViewModel, HomeViewState
```

**Dependency injection** is manual via factories:
- `AppFactory` → creates app-level dependencies
- `ScreenFactory` (conforms to `HomeViewFactory` + `HomeCoordinatorFactory`) → creates views/coordinators with injected dependencies

**Navigation** uses the Coordinator pattern: `AppCoordinator` → `HomeCoordinator`. Coordinators hold navigation state as `@Published` properties.

**State management**: `HomeViewModel` (ObservableObject) drives `HomeView` via `@StateObject`. Actions flow through `HomeViewModel.handle(_ intent:)`.

## Data Flow

User action → `HomeViewModel.handle(.onAddNewEvent)` → `AddEventsUseCase` → `ActivityRepositoryImpl` → `UserDefaultsActivityDataSource` (persists via `UserDefaults` + `Codable`)

On load: `GetEventsUseCase` fetches stored events → ViewModel builds heatmap levels via `buildDailyScore()` + `buildLevelsLastWeeks()`.

## Core Model

```swift
struct ActivityEvent: Identifiable, Equatable, Codable {
    let id: UUID
    let date: Date
    let type: ActivityType   // .gym | .english | .coding
    let value: Int           // gym: sessions count; others: minutes
}
```

Heatmap scoring: Gym = 2 pts/session; English/Coding = 1 pt per 20 min. Scores normalized to levels 0–4.

## Testing

Uses **Swift Testing** (Apple's new framework, not XCTest). Test files are in `HeatMapTests/` and `HeatMapUITests/`. Current test coverage is minimal/placeholder.

## Key Conventions

- Coordinators manage navigation state; views never push routes directly
- All screen creation goes through `ScreenFactory` to keep DI centralized
- View state is a plain struct (`HomeViewState`) held by the ViewModel — avoid adding logic to state types
- Heatmap calculation logic lives in `HomeViewModel`; avoid duplicating it in views
