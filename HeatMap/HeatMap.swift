//
//  HeatMap.swift
//  HeatMap
//
//  Created by Damir Aushenov on 12/2/26.
//

import SwiftUI


struct HeatMap: View {
    var cell: CGFloat
    var gap: CGFloat
    
    @State private var showingAdd = false
    
    @State private var events: [ActivityEvent] = []
    
    

       // пример: последние 20
       var recentEvents: [ActivityEvent] {
           
           events.sorted { $0.date > $1.date }.prefix(20).map { $0 }
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

    /// Swift port of `_buildLevelsLastWeeks`
    /// - Parameters:
    ///   - dailyScore: map of Date(startOfDay) -> score for that day
    ///   - weeks: number of week columns to show
    ///   - calendar: calendar used for weekday + startOfDay calculations
    /// - Returns: levels array of length `weeks * 7` with values in 0...4 (oldest -> newest)
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
    
    var body: some View {
        let weeks = 2
        let dailyScore = buildDailyScore(events: events)
        let levels = buildLevelsLastWeeks(dailyScore: dailyScore, weeks: weeks)
        VStack {
           
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
      
        .sheet(isPresented: $showingAdd) {
                   AddActivitySheet { type, value in
                       // ✅ Add activity "today" (now)
                       let newEvent = ActivityEvent(date: .now, type: type, value: value)
                       print("events count:", events.count)
                       events.append(newEvent)
                   }
               }
        
        
        
    }
        
}
extension Array {
    subscript(safe index: Int) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}


struct AddActivitySheet: View {
    @Environment(\.dismiss) private var dismiss

    @State private var type: ActivityType = .english
    @State private var valueText: String = "20"

    let onSave: (ActivityType, Int) -> Void

    var body: some View {
        NavigationView {
            Form {
                Picker("Type", selection: $type) {
                    Text("Gym").tag(ActivityType.gym)
                    Text("English").tag(ActivityType.english)
                    Text("Coding").tag(ActivityType.coding)
                }

                TextField(type == .gym ? "Sessions" : "Minutes", text: $valueText)
                    .keyboardType(.numberPad)
            }
            .navigationTitle("Add Activity")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let v = Int(valueText.trimmingCharacters(in: .whitespaces)) ?? 0
                        guard v > 0 else { return }
                        onSave(type, v)
                        dismiss()
                    }
                }
            }
        }
    }
}
