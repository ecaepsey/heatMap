//
//  AppCoordinatorView.swift
//  HeatMap
//
//  Created by Damir Aushenov on 22/2/26.
//

import SwiftUI



struct AppCoordinatorView: View {
    
    private let screenFactory: ScreenFactory
        @ObservedObject private var coordinator: AppCoordinator

        init(screenFactory: ScreenFactory, coordinator: AppCoordinator) {
            self.screenFactory = screenFactory
            self.coordinator = coordinator
        }
    
    var body: some View {
        sceneView
        .onAppear {
            coordinator.handle(.showMain)
                    }
    }
    
    @ViewBuilder
       private var sceneView: some View {
           switch coordinator.state {
        
           

           case .main:
               MainCoordinatorView(
                   factory: screenFactory,
                   showAuthSceneHandler: { coordinator.handle(.showMain) }
               )
           }
       }
}
