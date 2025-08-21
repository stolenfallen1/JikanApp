//
//  MoreDetailsAnimeView.swift
//  JikanAPP
//
//  Created by Jhon Llyod Quizeo on 8/21/25.
//

import SwiftUI

struct MoreDetailsAnimeView: View {
    let anime: Anime   // summary from list
    @StateObject private var viewModel = AnimeDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                AsyncImage(url: URL(string: anime.images.jpg.image_url)) { phase in
                    switch phase {
                    case .empty: ProgressView()
                    case .success(let image):
                        image.resizable()
                            .scaledToFit()
                    case .failure:
                        Image(systemName: "xmark.octagon")
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(maxHeight: 300)
                .cornerRadius(12)
                
                Text(anime.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                Divider()
                
                // Hydrate with detail data
                if let detail = viewModel.detail {
                    if let synopsis = detail.synopsis {
                        Text(synopsis)
                            .font(.body)
                    }
                    
                    if let background = detail.background {
                        Text("Background")
                            .font(.headline)
                        Text(background)
                            .font(.body)
                    }
                    
                    if let episodes = detail.episodes {
                        Text("Episodes: \(episodes)")
                            .font(.subheadline)
                    }
                    
                    if let duration = detail.duration {
                        Text("Duration: \(duration)")
                            .font(.subheadline)
                    }
                } else {
                    ProgressView("Loading more details...")
                }
            }
            .padding()
        }
        .navigationTitle(anime.title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchDetails(for: anime.id)
        }
    }
}

#Preview {
//    MoreDetailsAnimeView()
}
