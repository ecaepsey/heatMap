//
//  ActivityList.swift
//  HeatMap
//
//  Created by Damir Aushenov on 17/2/26.
//



import SwiftUI

struct ActivityListUnderHeatmap: View {
    let events: [ActivityEvent]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Recent activity")
                    .font(.title3).bold()
                Spacer()
            }

            if events.isEmpty {
                Text("No activity yet")
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 8)
            } else {
                LazyVStack(spacing: 10) {
                    ForEach(events) { event in
                        ActivityRow(event: event)
                    }
                }
            }
        }
    }
}
