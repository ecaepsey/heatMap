//
//  AppCoordinator.swift
//  HeatMap
//
//  Created by Damir Aushenov on 22/2/26.
//

import Foundation

@MainActor
final class AppCoordinator: ObservableObject {
    
    enum State {
        case main
    }
    
    enum Action {
        case showMain
    }
    
    init() {
        state = .main
    }
    
    @Published private(set) var state: State
    
    func handle(_ action: Action) {
           
    }
}
