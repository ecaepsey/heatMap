//
//  ActivityRow.swift
//  HeatMap
//
//  Created by Damir Aushenov on 17/2/26.
//

import SwiftUI

struct ActivityRow: View {
    let event: ActivityEvent

    private var subtitle: String {
        switch event.type {
        case .gym:
            return "\(event.value) session"
        case .english, .coding:
            return "\(event.value) min"
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: event.type.systemImage)
                .frame(width: 28)
                .font(.system(size: 18))

            VStack(alignment: .leading, spacing: 2) {
                Text(event.type.title).font(.headline)
                Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
            }

            Spacer()

            Text(event.date, format: .dateTime.month().day())
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
