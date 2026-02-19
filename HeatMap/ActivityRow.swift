//
//  ActivityRow.swift
//  HeatMap
//
//  Created by Damir Aushenov on 17/2/26.
//

import SwiftUI
import UIKit

struct ActivityRow: View {
    let event: ActivityEvent

    private var subtitle: String {
        switch event.type {
        case .gym:
            return "\(event.value) session"
        case .english, .coding:
            return "\(event.value) min"
        }
    }
    
    func test() {
        let view: AnyObject = UIButton()
        
        for label in view.subviews where label is UILabel {
            print("Found a label \(label.frame)")
        }
        
        for i in 1...100 where i % 8 == 0 {
            print(i)
        }
        
        for i in 1...20 where i % 3 == 0 && i % 5 == 0 {
            
        }
        
        
        
        let age = 36
        
        if (0 ..< 18).contains(age) {
            
        }
        
        if case 0 ..< 18 = age {
            print("You have the energy and time, but not the money")
        } else if case 18 ..< 70 = age {
            print("some thing")
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: event.type.systemImage)
                .frame(width: 28)
                .font(.system(size: 18))

            VStack(alignment: .leading, spacing: 2) {
                Text(event.type.title).font(.headline)
                Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
            }

            Spacer()

            Text(event.date, format: .dateTime.month().day())
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}


class Singer {
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    func reversedName() -> String {
        return "\(name.uppercased().reversed())"
    }
}

