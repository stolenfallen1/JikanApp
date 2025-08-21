//
//  AnimeDetailViewModel.swift
//  JikanAPP
//
//  Created by Jhon Llyod Quizeo on 8/21/25.
//

import Foundation

@MainActor
class AnimeDetailViewModel: ObservableObject {
    @Published var detail: AnimeDetail? = nil
    @Published var isLoading = false
    
    func fetchDetails(for id: Int) async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        let urlString = "https://api.jikan.moe/v4/anime/\(id)/full"
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(AnimeDetailResponse.self, from: data)
            detail = decoded.data
        } catch {
            print("Failed to fetch anime details: \(error.localizedDescription)")
        }
    }
}
