//
//  MoreDetailsMangaView.swift
//  JikanAPP
//
//  Created by Jhon Llyod Quizeo on 8/21/25.
//

import SwiftUI

struct MoreDetailsMangaView: View {
    let manga: Manga // summary from list
    @StateObject private var viewModel = MangaDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                AsyncImage(url: URL(string: manga.images.jpg.image_url)) { phase in
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
                
                Text(manga.title)
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
                    
                    if let chapters = detail.chapters {
                        Text("Chapters: \(chapters)")
                            .font(.subheadline)
                    }
                    
                    if let volumes = detail.volumes {
                        Text("Volumes: \(volumes)")
                            .font(.subheadline)
                    }
                } else {
                     ProgressView("Loading more details...")
                }
            }
            .padding()
        }
        .navigationTitle(manga.title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchDetails(for: manga.id)
        }
    }
}

#Preview {
//    MoreDetailsMangaView()
}
