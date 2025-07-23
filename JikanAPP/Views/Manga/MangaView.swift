//
//  MangaView.swift
//  JikanAPP
//
//  Created by stolenfallen1 on 7/22/25.
//

import SwiftUI

struct MangaView: View {
    let items = Array(1...20)
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(items, id: \.self) { item in
                    MangaItemView(item: item)
                }
                .padding()
            }
            .navigationTitle("Manga")
        }
    }
}

struct MangaItemView: View {
    let item: Int
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.blue.opacity(0.7))
            .frame(height: 20)
            .overlay {
                Text("Manga \(item)")
                    .foregroundColor(.white)
                    .bold()
            }
    }
}

#Preview {
    MangaView()
}
