//
//  GetEventsUseCase.swift
//  HeatMap
//
//  Created by Damir Aushenov on 24/2/26.
//

import Foundation


final class GetEventsUseCase {
    private let activityRepository: ActivityRepository
    
    init(activityRepository: ActivityRepository) {
        self.activityRepository = activityRepository
    }
    
    func callAsFunction() -> [ActivityEvent] { activityRepository.loadEvents() }
}
