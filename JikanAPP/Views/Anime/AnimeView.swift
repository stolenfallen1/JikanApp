//
//  HomeView.swift
//  JikanAPP
//
//  Created by stolenfallen1 on 7/22/25.
//

import SwiftUI

struct AnimeView: View {
    let items = Array(1...20)
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(items, id: \.self) { item in
                    AnimeItemView(item: item)
                }
                .padding()
            }
            .navigationTitle("Anime")
        }
    }
}

struct AnimeItemView: View {
    let item: Int
    
    var body: some View {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.blue.opacity(0.7))
                .frame(height: 20)
                .overlay {
                    Text("Anime \(item)")
                        .foregroundColor(.white)
                        .bold()
                }
    }
}

#Preview {
//    AnimeView()
}
