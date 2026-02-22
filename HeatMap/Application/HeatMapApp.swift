//
//  HeatMapApp.swift
//  HeatMap
//
//  Created by Damir Aushenov on 22/2/26.
//

import SwiftUI

@main
struct HeatMapApp: App {
    private let appFactory = AppFactory()
    
    
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(
                            screenFactory: ScreenFactory(appFactory: appFactory),
                            coordinator: AppCoordinator(
                               
                            )
                        )
            .preferredColorScheme(.light)
                        
        }
    }
}
