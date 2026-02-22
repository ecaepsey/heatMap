//
//  MainCoordinatorVIew.swift
//  HeatMap
//
//  Created by Damir Aushenov on 22/2/26.
//

import SwiftUI

struct MainCoordinatorView: View {

    enum Tab {
        case home
      
    }

    @State private var selectedTab = Tab.home

    private let factory: ScreenFactory
    private let homeCoordinator: HomeCoordinator
    

    init(factory: ScreenFactory, showAuthSceneHandler: @escaping () -> Void) {
        self.factory = factory

        homeCoordinator = .init(showAuthSceneHandler: showAuthSceneHandler)
       
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeCoordinatorView(homeCoordinator, factory: factory)
                .tabItem {
                    Label("Главная", systemImage: Constants.houseImage)
                }
                .tag(Tab.home)

            
        }
        
        .onAppear {
            setupTabBar()
        }
    }

    private enum Constants {
        static let houseImage = "house"
        static let heartImage = "heart"
        static let person = "person"
    }

    @MainActor private func setupTabBar() {
       
        UITabBar.appearance().isTranslucent = true

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = UITabBar.appearance().standardAppearance
    }
}
