//
//  HomeView.swift
//  JikanAPP
//
//  Created by stolenfallen1 on 7/22/25.
//

import SwiftUI

enum AnimeFilter: String {
    case top = "Top Anime"
    case reviews = "High Reviews"
}

struct AnimeView: View {
    @StateObject private var topAnimeViewModel = TopAnimeViewModel()
    @StateObject private var highReviewAnimeViewModel = HighReviewAnimeViewModel()
    @State private var selectedFilter: AnimeFilter = .top
    
    let columns = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        ScrollView {
            if selectedFilter == .top {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(topAnimeViewModel.topAnimeList) { anime in
                        TopAnimeItemView(topAnime: anime)
                    }
                    .padding()
                }
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(highReviewAnimeViewModel.highReviewAnimeList) { anime in
                        HighReviewAnimeItemView(highReviewAnime: anime)
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(selectedFilter.rawValue)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("Top Anime") {
                        selectedFilter = .top
                        Task { await topAnimeViewModel.fetchTopAnime() }
                    }
                    Button("High Reviews") {
                        selectedFilter = .reviews
                        Task { await highReviewAnimeViewModel.fetchHighReviewAnime() }
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .imageScale(.large)
                }
            }
        }
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color(.systemBackground), for: .navigationBar)
        .task {
            if selectedFilter == .top {
                await topAnimeViewModel.fetchTopAnime()
            } else {
                await highReviewAnimeViewModel.fetchHighReviewAnime()
            }
        }
    }
}

struct TopAnimeItemView: View {
    let topAnime: TopAnime
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: topAnime.images.jpg.image_url)) { phase in
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
            Text(topAnime.title)
                .font(.caption)
                .lineLimit(2)
                .padding([.leading, .trailing], 4)
        }
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
}

struct HighReviewAnimeItemView: View {
    let highReviewAnime: HighReviewAnime
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: highReviewAnime.entry.images.jpg.image_url)) { phase in
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
            Text(highReviewAnime.entry.title)
                .font(.caption)
                .lineLimit(2)
                .padding([.leading, .trailing], 4)
            
            Text("⭐️ \(highReviewAnime.score)")
                .font(.caption2)
                .foregroundColor(.orange)
        }
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
//    AnimeView()
}
