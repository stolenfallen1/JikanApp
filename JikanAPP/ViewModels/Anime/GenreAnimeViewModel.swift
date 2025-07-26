//
//  GenreAnimeViewModel.swift
//  JikanAPP
//
//  Created by stolenfallen1 on 7/26/25.
//

import Foundation

@MainActor
class GenreAnimeViewModel: ObservableObject {
    @Published var animeList: [Anime] = []
    
    func fetchAnime(for genreID: Int) async {
        let urlString = "https://api.jikan.moe/v4/anime?genres=\(genreID)"
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(AnimeResponse.self, from: data)
            animeList = decoded.data
        } catch {
            print("Failed to fetch anime base on genre: \(error.localizedDescription)")
        }
    }
}
