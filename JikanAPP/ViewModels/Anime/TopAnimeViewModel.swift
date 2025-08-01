//
//  TopAnimeViewModel.swift
//  JikanAPP
//
//  Created by stolenfallen1 on 7/23/25.
//

import Foundation

@MainActor
class TopAnimeViewModel: ObservableObject {
    @Published var topAnimeList: [Anime] = []
    
    func fetchTopAnime() async {
        let urlString = "https://api.jikan.moe/v4/top/anime"
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(AnimeResponse.self, from: data)
            topAnimeList = decoded.data
        } catch {
            print("Failed to fetch anime: \(error.localizedDescription)")
        }
    }
}
