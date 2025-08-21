//
//  MangaDetailViewModel.swift
//  JikanAPP
//
//  Created by Jhon Llyod Quizeo on 8/21/25.
//

import Foundation

@MainActor
class MangaDetailViewModel: ObservableObject {
    @Published var detail: MangaDetail? = nil
    @Published var isLoading = false
    
    func fetchDetails(for id: Int) async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        let urlString = "https://api.jikan.moe/v4/manga/\(id)/full"
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(MangaDetailResponse.self, from: data)
            detail = decoded.data
        } catch {
            print("Failed to fetch manga details: \(error.localizedDescription)")
        }
    }
}
