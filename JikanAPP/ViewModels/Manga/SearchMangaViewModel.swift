//
//  SearchMangaViewModel.swift
//  JikanAPP
//
//  Created by stolenfallen1 on 7/27/25.
//

import Foundation

@MainActor
class SearchMangaViewModel: ObservableObject {
    @Published var searchResults: [Manga] = []
    
    func searchManga(query: String) async {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.jikan.moe/v4/manga?q=\(encoded)"
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(MangaResponse.self, from: data)
            searchResults = decoded.data
        } catch {
            print("Manga search error: \(error.localizedDescription)")
        }
    }
}
