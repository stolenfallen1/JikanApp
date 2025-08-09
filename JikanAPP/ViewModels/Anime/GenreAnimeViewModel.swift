//
//  GenreAnimeViewModel.swift
//  JikanAPP
//
//  Created by stolenfallen1 on 7/26/25.
//

import Foundation

@MainActor
class GenreAnimeViewModel: ObservableObject, InfiniteLoadingViewModel {
    @Published var animeList: [Anime] = []
    @Published var isLoadingMore: Bool = false
    @Published var hasMorePages: Bool = true
    @Published var currentPage: Int = 1
    
    private var currentGenreID: Int?
    
    func fetchAnime(for genreID: Int) async {
        // Reset pagination when fetching a new genre
        if currentGenreID != genreID {
            currentGenreID = genreID
            currentPage = 1
            hasMorePages = true
            animeList = []
        }
        
        let urlString = "https://api.jikan.moe/v4/anime?genres=\(genreID)&page=\(currentPage)"
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(AnimeResponse.self, from: data)
            
            if currentPage == 1 {
                animeList = decoded.data
            } else {
                animeList.append(contentsOf: decoded.data)
            }
            
            hasMorePages = decoded.data.count >= 25
            
        } catch {
            print("Failed to fetch anime base on genre: \(error.localizedDescription)")
        }
    }
    
    func loadMoreIfNeeded(genreID: Int) async {
        guard !isLoadingMore && hasMorePages && currentGenreID == genreID else { return }
        
        isLoadingMore = true
        currentPage += 1
        
        await fetchAnime(for: genreID)
        
        isLoadingMore = false
    }
}
