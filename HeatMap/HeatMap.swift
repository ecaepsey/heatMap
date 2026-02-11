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
    var weeks: Int
    var levels: [Int]
    private func color(level: Int) -> Color {
         switch level {
         case 0: return Color(.systemGray5)
                case 1: return Color.green.opacity(0.25)
                case 2: return Color.green.opacity(0.40)
                case 3: return Color.green.opacity(0.60)
                default: return Color.green.opacity(0.85)
         }
     }
    
    var body: some View {
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
    }
}
extension Array {
    subscript(safe index: Int) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}
