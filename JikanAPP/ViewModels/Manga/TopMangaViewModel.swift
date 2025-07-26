//
//  TopMangaViewModel.swift
//  JikanAPP
//
//  Created by stolenfallen1 on 7/23/25.
//

import Foundation

@MainActor
class TopMangaViewModel: ObservableObject {
    @Published var topMangaList: [Manga] = []
    
    func fetchTopManga() async {
        let urlString = "https://api.jikan.moe/v4/top/manga"
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(MangaResponse.self, from: data)
            topMangaList = decoded.data
        } catch {
            print("Failed to fetch top manga: \(error.localizedDescription)")
        }
    }
}
