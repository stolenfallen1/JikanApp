//
//  GenreListViewModel.swift
//  JikanAPP
//
//  Created by stolenfallen1 on 7/26/25.
//

import Foundation

@MainActor
class GenreListViewModel: ObservableObject {
    @Published var genres: [Genres] = []
    
    func fetchGenres(for type: String) async {
        let urlString = "https://api.jikan.moe/v4/genres/\(type)"
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(GenreResponse.self, from: data)
            genres = decoded.data
        } catch {
            print("Failed to fetch genres: \(error.localizedDescription)")
        }
    }
}
