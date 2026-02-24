//
//  HomeViewModel.swift
//  HeatMap
//
//  Created by Damir Aushenov on 22/2/26.
//

import Foundation


class HomeViewModel: ViewModel {
    @Published private(set) var state: HomeViewState
    
    private let coordinator: HomeCoordinatorProtocol
    
    private let getEvents: GetEventsUseCase
    private let addEvent: AddEventsUseCase

    
    init(coordinator: HomeCoordinatorProtocol, getEvents: GetEventsUseCase, addEvent: AddEventsUseCase) {
        state = .init()
       
        self.getEvents = getEvents
        self.addEvent = addEvent
        self.coordinator = coordinator
        state.activityEvents = getEvents()
    }
    
    func handle(_ event: HomeViewEvent) {
        switch event {
      
        case .onAddNewEvent(let newEvent):
            state.activityEvents = addEvent(newEvent)
               }
        }
    
    
    
    
}
