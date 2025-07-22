//
//  HomeView.swift
//  Fort
//
//  Created by Richard WIjaya Harianto on 18/07/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Image(systemName: "house.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
            Text("Selamat Datang!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            Text("Anda berhasil login.")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .navigationTitle("Dashboard")
        .navigationBarBackButtonHidden(true)
    }
}
