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
        HeatmapSection(levels: viewModel.state.heatmapLevels, events: viewModel.state.activityEvents)
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








