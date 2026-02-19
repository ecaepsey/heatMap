//
//  ContentView.swift
//  HeatMap
//
//  Created by Damir Aushenov on 12/2/26.
//

import SwiftUI
import Foundation
let activityEvent = [
    ActivityEvent(date: Date(), type: .coding, value: 1),
    ActivityEvent(date: Date(), type: .english, value: 1),
    ActivityEvent(date: Date(), type: .gym, value: 1),

]
struct ContentView: View {
   
    struct ActivityEvent {
      
        let date: Date
      
        let value: Int
    }
    func daily() -> [Date: Int] {
        var events: [ActivityEvent] = []
        let cal = Calendar.current
        let today = cal.startOfDay(for: .now)
        var result: [Date: Int] = [:]

        for i in 0..<30 {
            let day = cal.date(byAdding: .day, value: -i, to: today)!
            let value = (i % 4)        // 1..5
            events.append(ActivityEvent(date: day, value: value))
            result[day, default: 0] += value
        }

           return result
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
        let today = dateOnly(Date(), calendar: calendar)
        
        // Monday-start grid: Monday=1 ... Sunday=7 in many locales,
        // but in Calendar, weekday is 1...7 where 1 is Sunday by default.
        // We'll compute "days since Monday" reliably.
        //
        // Strategy:
        // - Determine weekday index where Monday=0 ... Sunday=6
        let weekday = calendar.component(.weekday, from: today) // 1..7 (Sun=1 by default)
        // Convert to Monday-based offset:
        // Sun(1)->6, Mon(2)->0, Tue(3)->1, ... Sat(7)->5
        let mondayOffset = (weekday + 5) % 7
        
        // Go back to the first cell (top-left) so the last cell corresponds near "today"
        let totalCells = weeks * 7
        let daysBack = (totalCells - 1) + mondayOffset
        guard let start = calendar.date(byAdding: .day, value: -daysBack, to: today) else {
            return Array(repeating: 0, count: totalCells)
        }
        
        // Build raw values for each cell (oldest -> newest)
        var values: [Int] = []
        values.reserveCapacity(totalCells)
        
        for i in 0..<totalCells {
            guard let day = calendar.date(byAdding: .day, value: i, to: start) else {
                values.append(0)
                continue
            }
            let key = dateOnly(day, calendar: calendar)
            values.append(dailyScore[key] ?? 0)
        }
        
        // 90th percentile reference to avoid one crazy day flattening everything
        let sorted = values.sorted()
        let idx = min(max(Int(floor(Double(sorted.count) * 0.90)), 0), sorted.count - 1)
        let p90 = sorted[idx]
        let maxRef = max(1, p90)
        
        // Map to 0...4 levels
        return values.map { v in
            if v <= 0 { return 0 }
            let level = Int(floor((Double(v) / Double(maxRef)) * 4.0))
            return min(max(level, 1), 4)
        }
        
        
    }
    
   
        
        
        var body: some View {
            
            TabView {
                       Tab("Home", systemImage: "house") {
                           HeatMap(cell: 14, gap: 4, weeks: 15, levels: buildLevelsLastWeeks(dailyScore: daily(), weeks: 16))
                       }
                      
                   }
            
            
            
             
            
            
                .padding()
        }
        
    
}

#Preview {
    
   
    
    

   
    
   

    ContentView()
}
