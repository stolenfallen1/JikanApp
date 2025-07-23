//
//  MangaView.swift
//  JikanAPP
//
//  Created by stolenfallen1 on 7/22/25.
//

import SwiftUI

struct MangaView: View {
    @StateObject private var viewModel = MangaViewModel()
    let columns = [GridItem(.adaptive(minimum: 150))]
    

    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.mangaList) { manga in
                    MangaItemView(manga: manga)
                }
                .padding()
            }
            .navigationTitle("Top Manga")
        }
        .task {
            await viewModel.fetchTopManga()
        }
    }
}

struct MangaItemView: View {
    let manga: Manga
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: manga.images.jpg.image_url)) { phase in
                switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 20)
                            .clipped()
                    case .failure(let error):
                        Image(systemName: "xmark.octagon")
                    @unknown default:
                        EmptyView()
                }
            }
            Text(manga.title)
                .font(.caption)
                .lineLimit(2)
                .padding([.leading, .trailing], 4)
        }
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
//    MangaView()
}
