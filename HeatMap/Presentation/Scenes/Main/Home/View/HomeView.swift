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
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
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
        HeatmapSection(levels: viewModel.state.heatmapLevels, events: viewModel.state.activityEvents)
    }
}


struct HeatmapSection: View {
    let levels: [Int]
    let events: [ActivityEvent]

    @State private var availableWidth: CGFloat = 300

    private let weeks = 10
    private let gap: CGFloat = 4
    private let monthLabelHeight: CGFloat = 14
    private let weekdayLabelWidth: CGFloat = 22
    private let hstackSpacing: CGFloat = 6

    private var cell: CGFloat {
        let gridWidth = availableWidth - weekdayLabelWidth - hstackSpacing
        return max(10, (gridWidth - gap * CGFloat(weeks - 1)) / CGFloat(weeks))
    }

    private var calendar: Calendar { .current }

    private var startDate: Date {
        let today = calendar.startOfDay(for: Date())
        return calendar.date(byAdding: .day, value: -(weeks * 7 - 1), to: today)!
    }

    private func weekdayLabel(for row: Int) -> String {
        let startWeekday = calendar.component(.weekday, from: startDate) - 1 // 0 = Sun
        let weekday = (startWeekday + row) % 7
        return ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"][weekday]
    }

    private func monthLabel(for week: Int) -> String? {
        let colDate = calendar.date(byAdding: .day, value: week * 7, to: startDate)!
        let curMonth = calendar.component(.month, from: colDate)
        if week == 0 { return calendar.shortMonthSymbols[curMonth - 1] }
        let prevDate = calendar.date(byAdding: .day, value: (week - 1) * 7, to: startDate)!
        let prevMonth = calendar.component(.month, from: prevDate)
        return curMonth != prevMonth ? calendar.shortMonthSymbols[curMonth - 1] : nil
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: hstackSpacing) {
                // Weekday labels on the left
                VStack(alignment: .trailing, spacing: gap) {
                    Color.clear.frame(height: monthLabelHeight)
                    ForEach(0..<7, id: \.self) { d in
                        Text(weekdayLabel(for: d))
                            .font(.system(size: 9))
                            .foregroundStyle(.secondary)
                            .frame(width: weekdayLabelWidth, height: cell)
                    }
                }

                // Month labels + heatmap grid
                VStack(alignment: .leading, spacing: gap) {
                    // Month labels row
                    HStack(spacing: gap) {
                        ForEach(0..<weeks, id: \.self) { w in
                            if let label = monthLabel(for: w) {
                                Text(label)
                                    .font(.system(size: 9))
                                    .foregroundStyle(.secondary)
                                    .fixedSize()
                                    .frame(width: cell, alignment: .leading)
                            } else {
                                Color.clear.frame(width: cell)
                            }
                        }
                    }
                    .frame(height: monthLabelHeight)

                    // Heatmap grid
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
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear { availableWidth = geo.size.width }
                        .onChange(of: geo.size.width) { availableWidth = $0 }
                }
            )

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








