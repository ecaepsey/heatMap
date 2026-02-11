//
//  HeatMapApp.swift
//  HeatMap
//
//  Created by Damir Aushenov on 12/2/26.
//

import SwiftUI

@main
struct HeatMapApp: App {
    var body: some Scene {
        WindowGroup {
            let cal = Calendar.current
            let today = cal.startOfDay(for: Date())

            var daily: [Date: Int] = [:]
            ContentView()
        }
    }
}
