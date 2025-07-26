//
//  GenreMangaViewModel.swift
//  JikanAPP
//
//  Created by stolenfallen1 on 7/26/25.
//

import Foundation

@MainActor
class GenreMangaViewModel: ObservableObject {
    @Published var mangaList: [Manga] = []
    
    func fetchManga(for genreID: Int) async {
        let urlString = "https://api.jikan.moe/v4/manga?genres=\(genreID)"
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(MangaResponse.self, from: data)
            mangaList = decoded.data
        } catch {
            print("Failed to fetch manga base on genre: \(error.localizedDescription)")
        }
    }
}
