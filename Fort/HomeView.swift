//
//  ContentView.swift
//  FortHome
//
//  Created by Elia K on 21/07/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack{
            Image("Mask group")
                .padding(.top, -660)
            VStack{
                Logo_HelpCentreView()
                    .padding(.top, 200)
                    .padding(.bottom, 40)
                RegisterBoxView()
                    .frame(width: 386, height: 200)
                    .padding(.bottom, 40)
                FinPlannerView()
                    .padding(.bottom, 500)

                    
            }
        }
    }
}

#Preview {
    HomeView()
}
