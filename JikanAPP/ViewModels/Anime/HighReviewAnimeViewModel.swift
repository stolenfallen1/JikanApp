//
//  HighReviewAnimeViewModel.swift
//  JikanAPP
//
//  Created by Jhon Llyod Quizeo on 7/24/25.
//

import Foundation

@MainActor
class HighReviewAnimeViewModel: ObservableObject {
    @Published var highReviewAnimeList: [HighReviewAnime] = []
    
    func fetchHighReviewAnime() async {
        let urlString = "https://api.jikan.moe/v4/top/reviews?type=anime"
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(HighReviewAnimeResponse.self, from: data)
            highReviewAnimeList = decoded.data
        } catch {
            print("Failed to fetch high review anime: \(error.localizedDescription)")
        }

    }
}
