//
//  HomeViewState.swift
//  HeatMap
//
//  Created by Damir Aushenov on 22/2/26.
//

import Foundation


enum HomeViewEvent {
   case onAddNewEvent(ActivityEvent)
}

struct HomeViewState: Equatable {
    var activityEvents: [ActivityEvent] = []
       var isLoading: Bool = false
       var error: String? = nil
}
