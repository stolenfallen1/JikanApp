//
//  MangaView.swift
//  JikanAPP
//
//  Created by stolenfallen1 on 7/22/25.
//

import SwiftUI

enum MangaFilter: String {
    case top = "Top Manga"
    case reviews = "High Reviews"
}

struct MangaView: View {
    @StateObject private var topMangaViewModel = TopMangaViewModel()
    @StateObject private var highReviewMangaViewModel = HighReviewMangaViewModel()
    @State private var selectedFilter: MangaFilter = .top

    let columns = [GridItem(.adaptive(minimum: 150))]

    var body: some View {
        ScrollView {
            if selectedFilter == .top {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(topMangaViewModel.topMangaList) { manga in
                        TopMangaItemView(topManga: manga)
                    }
                    .padding()
                }
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(highReviewMangaViewModel.highReviewMangaList) { manga in
                        HighReviewMangaItemView(highReviewManga: manga)
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
                    Button("Top Manga") {
                        selectedFilter = .top
                        Task { await topMangaViewModel.fetchTopManga() }
                    }
                    Button("High Reviews") {
                        selectedFilter = .reviews
                        Task { await highReviewMangaViewModel.fetchHighReviewManga() }
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
                await topMangaViewModel.fetchTopManga()
            } else {
                await highReviewMangaViewModel.fetchHighReviewManga()
            }
        }
    }
}


struct TopMangaItemView: View {
    let topManga: TopManga
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: topManga.images.jpg.image_url)) { phase in
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
            Text(topManga.title)
                .font(.caption)
                .lineLimit(2)
                .padding([.leading, .trailing], 4)
        }
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
}

struct HighReviewMangaItemView: View {
    let highReviewManga: HighReviewManga
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: highReviewManga.entry.images.jpg.image_url)) { phase in
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
            
            Text(highReviewManga.entry.title)
                .font(.caption)
                .lineLimit(2)
                .padding([.leading, .trailing], 4)
            
            Text("⭐️ \(highReviewManga.score)")
                .font(.caption2)
                .foregroundColor(.orange)
        }
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
//    MangaView()
}
