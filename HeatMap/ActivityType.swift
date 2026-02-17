//
//  ActivityType.swift
//  HeatMap
//
//  Created by Damir Aushenov on 17/2/26.
//



import Foundation

enum ActivityType: String {
    case gym, english, coding

    var title: String {
        switch self {
        case .gym: return "Gym"
        case .english: return "English"
        case .coding: return "Coding"
        }
    }

    var systemImage: String {
        switch self {
        case .gym: return "dumbbell"
        case .english: return "book"
        case .coding: return "chevron.left.slash.chevron.right"
        }
    }
}

struct ActivityEvent: Identifiable {
    let id = UUID()
    let date: Date
    let type: ActivityType
    let value: Int // gym: sessions, english/coding: minutes
}
