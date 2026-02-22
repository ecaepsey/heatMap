//
//  ScreenFactoryProtocols.swift
//  HeatMap
//
//  Created by Damir Aushenov on 22/2/26.
//

import Foundation


@MainActor
protocol HomeViewFactory {
    func makeHomeView(coordinator: HomeCoordinatorProtocol) -> HomeView
}
