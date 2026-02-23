//
//  HomeView.swift
//  HeatMap
//
//  Created by Damir Aushenov on 22/2/26.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var cell: CGFloat = 20
    var gap: CGFloat = 10
    
    @State private var showingAdd = false
    
  
    
    
    // пример: последние 20
  
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                                Text("Activity").font(.largeTitle).bold()
                                Spacer()
                                Button {
                                    showingAdd = true
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 28))
                                }
                            }

                  content
              }
        .sheet(isPresented: $showingAdd) {
            AddActivitySheet { type, value in
                // ✅ Add activity "today" (now)
                let newEvent = ActivityEvent(date: .now, type: type, value: value)
                
                viewModel.handle(.onAddNewEvent(newEvent))
                
            }
        }
    }
    
    @ViewBuilder
      private var content: some View {
          
          
        
        

        
              // ✅ use state data in UI
          let dailyScore = buildDailyScore(events: viewModel.state.activityEvents)
              let levels = buildLevelsLastWeeks(dailyScore: dailyScore, weeks: 10)

              HeatmapSection(levels: levels, events: viewModel.state.activityEvents)
          
      }
    
    func buildDailyScore(
        events: [ActivityEvent],
        calendar: Calendar = .current
    ) -> [Date: Int] {
        var result: [Date: Int] = [:]
        
        for e in events {
            let day = calendar.startOfDay(for: e.date)
            
            // MVP scoring:
            // gym: sessions * 2, others: minutes -> 1 point per 20 min
            let score: Int
            switch e.type {
            case .gym:
                score = 2 * e.value
            case .english, .coding:
                score = max(1, e.value / 20)
            }
            
            result[day, default: 0] += score
        }
        
        return result
    }
    
    func buildLevelsLastWeeks(
        dailyScore: [Date: Int],
        weeks: Int,
        calendar: Calendar = .current
    ) -> [Int] {
        let today = calendar.startOfDay(for: Date())
        
        let totalCells = weeks * 7
        let daysBack = (totalCells - 1) // ✅ без mondayOffset
        
        guard let start = calendar.date(byAdding: .day, value: -daysBack, to: today) else {
            return Array(repeating: 0, count: totalCells)
        }
        
        var values: [Int] = []
        values.reserveCapacity(totalCells)
        
        for i in 0..<totalCells {
            let day = calendar.date(byAdding: .day, value: i, to: start)!
            let key = calendar.startOfDay(for: day)
            values.append(dailyScore[key] ?? 0)
        }
        
        let maxRef = max(1, values.max() ?? 1)
        
        return values.map { v in
            if v <= 0 { return 0 }
            let level = Int(floor((Double(v) / Double(maxRef)) * 4.0))
            return min(max(level, 1), 4)
        }
    }
    
    private func color(level: Int) -> Color {
        switch level {
        case 0: return Color(.systemGray5)
        case 1: return Color.green.opacity(0.25)
        case 2: return Color.green.opacity(0.40)
        case 3: return Color.green.opacity(0.60)
        default: return Color.green.opacity(0.85)
        }
    }
    
    func dateOnly(_ date: Date, calendar: Calendar = .current) -> Date {
        return calendar.startOfDay(for: date)
    }
}


struct HeatmapSection: View {
    let levels: [Int]
    let events: [ActivityEvent]

    private let weeks = 10
    private let cell: CGFloat = 14
    private let gap: CGFloat = 4

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: gap) {
                    ForEach(0..<weeks, id: \.self) { w in
                        VStack(spacing: gap) {
                            ForEach(0..<7, id: \.self) { d in
                                let idx = w * 7 + d
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(color(level: levels[safe: idx] ?? 0))
                                    .frame(width: cell, height: cell)
                            }
                        }
                    }
                }
                .padding(.vertical, 8)
            }
            .frame(height: (cell * 7) + (gap * 6))

            ActivityListUnderHeatmap(events: events.sorted { $0.date > $1.date })
        }
    }

    private func color(level: Int) -> Color {
        switch level {
        case 0: return Color(.systemGray5)
        case 1: return .green.opacity(0.25)
        case 2: return .green.opacity(0.40)
        case 3: return .green.opacity(0.60)
        default: return .green.opacity(0.85)
        }
    }
}
