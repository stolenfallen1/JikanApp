//
//  SearchAnimeViewModel.swift
//  JikanAPP
//
//  Created by stolenfallen1 on 7/27/25.
//

import Foundation

@MainActor
class SearchAnimeViewModel: ObservableObject {
    @Published var searchResults: [Anime] = []
    
    func searchAnime(query: String) async {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.jikan.moe/v4/anime?q=\(encoded)"
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(AnimeResponse.self, from: data)
            searchResults = decoded.data
        } catch {
            print("Anime search error: \(error.localizedDescription)")
        }
    }
}
