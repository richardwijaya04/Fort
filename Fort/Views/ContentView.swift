//
//  ContentView.swift
//  Fort
//
//  Created by Richard WIjaya Harianto on 17/07/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            NavigationLink(destination: OCRView()) {
                Text("Pilih Foto")
                    .foregroundStyle(.blue)
            }
        }
    }
}

#Preview {
    ContentView()
}
