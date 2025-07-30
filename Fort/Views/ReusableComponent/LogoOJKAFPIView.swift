//
//  LogoOJKAFPIView.swift
//  Fort
//
//  Created by William on 24/07/25.
//

import SwiftUI

struct LogoOJKAFPIView: View {
    var body: some View {
        VStack {
            Text("Diawasi Oleh:")
                .font(.callout)
                .fontWeight(.semibold)
            HStack {
                Image("ojk").resizable().scaledToFit().frame(height: 36)
                Image("afpi").resizable().scaledToFit().frame(height: 36)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    LogoOJKAFPIView()
}
