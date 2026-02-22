//
//  ViewModel.swift
//  HeatMap
//
//  Created by Damir Aushenov on 22/2/26.
//

import Foundation

@MainActor
protocol ViewModel<State, Event>: ObservableObject where State: Equatable {
    associatedtype State
    associatedtype Event

    var state: State { get }

    func handle(_ event: Event)
}

