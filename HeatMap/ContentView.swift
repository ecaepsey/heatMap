//
//  ContentView.swift
//  HeatMap
//
//  Created by Damir Aushenov on 12/2/26.
//

import SwiftUI
import Foundation

struct ContentView: View {
   
    
   
   
    
   
   
    
   
        
        
        var body: some View {
            
            
            TabView {
                       Tab("Home", systemImage: "house") {
                           HeatMap(cell: 20, gap: 10)
                       }
                      
                   }
            
            
            
             
            
            
                .padding()
        }
        
    
}

#Preview {
    
   
    
    

   
    
   

    ContentView()
}
