//
//  CarouselCard.swift
//  Fort
//
//  Created by Dicky Dharma Susanto on 25/07/25.
//

import SwiftUI

struct Article: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
}

struct CarouselCard: View {
    let articles: [Article] = [
        Article(title: "Tips & Tricks Menghindari Fraud", imageName: "fraud"),
        Article(title: "Langkah Awal Menuju Pinjaman yang Aman dan Bijak", imageName: "secure-loan"),
        Article(title: "Tingkatan dan Literasi Keuangan yang Perlu Diketahui", imageName: "financial-literacy")
    ]
    
    @State private var currentIndex = 0
    private let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(articles.indices, id: \.self) { index in
                VStack(alignment: .leading, spacing: 8) {
                    Image(articles[index].imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 356, height: 113)
                        .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .topRight]))
                        .clipped()
                    
                    Text(articles[index].title)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.black)
                        .padding()
                    Spacer(minLength: 0)
                }
                .frame(width: 354, height: 250)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 8)
                .padding(.horizontal, 16)
                .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .onReceive(timer) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % articles.count
            }
        }
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}


#Preview {
    CarouselCard()
}
