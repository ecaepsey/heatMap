//
//  ScreenFactory.swift
//  HeatMap
//
//  Created by Damir Aushenov on 22/2/26.
//

import SwiftUI


final class ScreenFactory: HomeCoordinatorFactory {
    func makeHomeView(coordinator: any HomeCoordinatorProtocol) -> HomeView {
        
        let repo =  ActivityRepositoryImpl(ds: UserDefaultsActivityDataSource())
        let getEventUseCase = GetEventsUseCase(activityRepository: repo)
        let addEvent = AddEventsUseCase(activityRepository: repo)
        let viewModel = HomeViewModel(
                    coordinator: coordinator,
                    getEvents: getEventUseCase,
                    addEvent: addEvent
                )
                let view = HomeView(viewModel: viewModel)

                return view
    }
    
    
    
    private let appFactory: AppFactory
    
    init(appFactory: AppFactory) {
        self.appFactory = appFactory
    }
}
