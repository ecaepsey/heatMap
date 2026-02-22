//
//  HomeCoordinator.swift
//  HeatMap
//
//  Created by Damir Aushenov on 22/2/26.
//

import Foundation

final class HomeCoordinator: Coordinator {
    
    enum Screen: Routable {
       
    }
    
    @Published var navigationPath = [Screen]()
    private let showAuthSceneHandler: () -> Void
    
    init(showAuthSceneHandler: @escaping () -> Void) {
        self.showAuthSceneHandler = showAuthSceneHandler
    }
}

extension HomeCoordinator: HomeCoordinatorProtocol {
    
    func showAuthScene() {
        showAuthSceneHandler()
    }
    
    func showMovieDetails(_ movieId: String) {
        
    }
}
