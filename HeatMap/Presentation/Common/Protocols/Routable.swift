//
//  Routable.swift
//  HeatMap
//
//  Created by Damir Aushenov on 22/2/26.
//



import Foundation

protocol Routable: Hashable, Identifiable {}

extension Routable {
    var id: String {
        String(describing: self)
    }
}
