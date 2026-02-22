//
//  Coordinator.swift
//  HeatMap
//
//  Created by Damir Aushenov on 22/2/26.
//



import SwiftUI

protocol Coordinator: ObservableObject where Screen: Routable {
    associatedtype Screen
    var navigationPath: [Screen] { get }
}
