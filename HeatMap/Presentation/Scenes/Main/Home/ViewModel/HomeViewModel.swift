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
    
    init(coordinator: HomeCoordinatorProtocol) {
        state = .init()
        self.coordinator = coordinator
    }
    
    func handle(_ event: HomeViewEvent) {
        switch event {
      
        case .onAddNewEvent(let newEvent):
                   state.activityEvents.append(newEvent)

               }
        }
    
    
    
    
}
