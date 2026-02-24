//
//  AddEventUseCase.swift
//  HeatMap
//
//  Created by Damir Aushenov on 24/2/26.
//

import Foundation


final class AddEventsUseCase {
    private let activityRepository: ActivityRepository
    
    init(activityRepository: ActivityRepository) {
        self.activityRepository = activityRepository
    }
    
    func callAsFunction(_ event: ActivityEvent) -> [ActivityEvent] {
        var events = activityRepository.loadEvents()
        events.append(event)
        activityRepository.saveEvents(events)
        return events
    }
}
