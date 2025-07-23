//
//  HomeView.swift
//  JikanAPP
//
//  Created by stolenfallen1 on 7/22/25.
//

import SwiftUI

struct AnimeView: View {
    @StateObject private var viewModel = AnimeViewModel()
    let columns = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.animeList) { anime in
                    AnimeItemView(anime: anime)
                }
                .padding()
            }
            .navigationTitle("Anime")
        }
        .task {
            await viewModel.fetchTopAnime()
        }
    }
}

struct AnimeItemView: View {
    let anime: Anime
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: anime.images.jpg.image_url)) { phase in
                switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 20)
                            .clipped()
                    case .failure:
                        Image(systemName: "xmark.octagon")
                    @unknown default:
                        EmptyView()
                }
            }
            Text(anime.title)
                .font(.caption)
                .lineLimit(2)
                .padding([.leading, .trailing], 4)
        }
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
//    AnimeView()
}
