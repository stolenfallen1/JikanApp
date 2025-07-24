//
//  HighReviewMangaViewModel.swift
//  JikanAPP
//
//  Created by Jhon Llyod Quizeo on 7/24/25.
//

import Foundation

@MainActor
class HighReviewMangaViewModel: ObservableObject {
    @Published var highReviewMangaList: [HighReviewManga] = []
    
    func fetchHighReviewManga() async {
        let urlString = "https://api.jikan.moe/v4/top/reviews?type=manga"
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(HighReviewMangaResponse.self, from: data)
            highReviewMangaList = decoded.data
        } catch {
            print("Failed to fetch high review manga: \(error.localizedDescription)")
        }
    }
}
