//
//  HomeViewModel.swift
//  HeatMap
//
//  Created by Damir Aushenov on 22/2/26.
//

import Foundation


class HomeViewModel: ViewModel {
    @Published private(set) var state: HomeViewState
    
    private let coordinator: HomeCoordinatorProtocol
    
    private let getEvents: GetEventsUseCase
    private let addEvent: AddEventsUseCase

    
    init(coordinator: HomeCoordinatorProtocol, getEvents: GetEventsUseCase, addEvent: AddEventsUseCase) {
        state = .init()

        self.getEvents = getEvents
        self.addEvent = addEvent
        self.coordinator = coordinator
        state.activityEvents = getEvents()
        state.heatmapLevels = Self.buildLevels(from: state.activityEvents)
    }

    func handle(_ event: HomeViewEvent) {
        switch event {
        case .onAddNewEvent(let newEvent):
            state.activityEvents = addEvent(newEvent)
            state.heatmapLevels = Self.buildLevels(from: state.activityEvents)
        }
    }

    // MARK: - Heatmap calculation

    private static let heatmapWeeks = 10

    /// Entry point: converts a list of activity events into heatmap levels ready for the view.
    /// Chains `buildDailyScore` → `buildLevelsLastWeeks` and returns the result.
    private static func buildLevels(
        from events: [ActivityEvent],
        calendar: Calendar = .current
    ) -> [Int] {
        let dailyScore = buildDailyScore(from: events, calendar: calendar)
        return buildLevelsLastWeeks(dailyScore: dailyScore, weeks: heatmapWeeks, calendar: calendar)
    }

    /// Aggregates all activity events into a per-day score map.
    ///
    /// Scoring rules:
    /// - Gym: 2 points per session
    /// - English / Coding: 1 point per 20 minutes (minimum 1 point)
    ///
    /// Multiple events on the same day are summed together.
    /// Returns `[startOfDay: totalScore]`.
    private static func buildDailyScore(
        from events: [ActivityEvent],
        calendar: Calendar = .current
    ) -> [Date: Int] {
        var result: [Date: Int] = [:]
        for event in events {
            let day = calendar.startOfDay(for: event.date)
            let score: Int
            switch event.type {
            case .gym:
                score = 2 * event.value
            case .english, .coding:
                score = max(1, event.value / 20)
            }
            result[day, default: 0] += score
        }
        return result
    }

    /// Converts a daily-score map into an array of heatmap levels (0–4) for the last N weeks.
    ///
    /// How it works:
    /// 1. Calculates the start date as `today - (weeks * 7 - 1)` days, so the last cell is always today.
    /// 2. Builds a raw `values` array of length `weeks * 7` — one score per day, oldest first.
    /// 3. Finds `maxRef` (the highest score in the window) to use as the normalization ceiling.
    /// 4. Maps each score to a level:
    ///    - 0 → no activity that day
    ///    - 1–4 → `floor(score / maxRef * 4)`, clamped so any activity is at least level 1.
    ///
    /// The returned array is ordered oldest → newest, matching the left-to-right column layout in the heatmap grid.
    private static func buildLevelsLastWeeks(
        dailyScore: [Date: Int],
        weeks: Int,
        calendar: Calendar = .current
    ) -> [Int] {
        let today = calendar.startOfDay(for: Date())
        let totalCells = weeks * 7

        guard let start = calendar.date(byAdding: .day, value: -(totalCells - 1), to: today) else {
            return Array(repeating: 0, count: totalCells)
        }

        let values = (0..<totalCells).map { i -> Int in
            let day = calendar.date(byAdding: .day, value: i, to: start)!
            return dailyScore[day] ?? 0
        }

        let maxRef = max(1, values.max() ?? 1)

        return values.map { v in
            guard v > 0 else { return 0 }
            return min(max(Int(floor(Double(v) / Double(maxRef) * 4.0)), 1), 4)
        }
    }
}
