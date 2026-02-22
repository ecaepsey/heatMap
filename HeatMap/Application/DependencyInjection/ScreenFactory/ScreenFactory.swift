//
//  ScreenFactory.swift
//  HeatMap
//
//  Created by Damir Aushenov on 22/2/26.
//

import SwiftUI


final class ScreenFactory: HomeCoordinatorFactory {
    func makeHomeView(coordinator: any HomeCoordinatorProtocol) -> HomeView {
        let viewModel = HomeViewModel(
                    coordinator: coordinator
                   
                )
                let view = HomeView(viewModel: viewModel)

                return view
    }
    
    
    
    private let appFactory: AppFactory
    
    init(appFactory: AppFactory) {
        self.appFactory = appFactory
    }
}
