//
//  ContentView.swift
//  Fort
//
//  Created by Lin Dan Christiano on 22/07/25.
//

import SwiftUI

struct ContentView: View {
    let onNext: () -> Void
    let onPrevious: () -> Void
    
    var body: some View {
        VStack {
            Text("Content Section")
                .font(.largeTitle)
                .padding()
            
            Text("This is your content view")
                .font(.body)
                .padding()
            
            Spacer()
            
            // Navigation buttons
            HStack {
                Button("Previous") {
                    onPrevious()
                }
                .padding()
                
                Button("Next") {
                    onNext()
                }
                .padding()
            }
            .tint(.primary)
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
}
