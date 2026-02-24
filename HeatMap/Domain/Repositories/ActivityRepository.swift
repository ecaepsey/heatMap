//
//  ActivityRepository.swift
//  HeatMap
//
//  Created by Damir Aushenov on 24/2/26.
//

import Foundation

protocol ActivityRepository {
    func loadEvents() -> [ActivityEvent]
    func saveEvents(_ events: [ActivityEvent])
}
