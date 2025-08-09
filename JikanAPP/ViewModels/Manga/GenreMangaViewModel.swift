//
//  GenreMangaViewModel.swift
//  JikanAPP
//
//  Created by stolenfallen1 on 7/26/25.
//

import Foundation

@MainActor
class GenreMangaViewModel: ObservableObject, InfiniteLoadingViewModel {
    @Published var mangaList: [Manga] = []
    @Published var isLoadingMore: Bool = false
    @Published var hasMorePages: Bool = true
    @Published var currentPage: Int = 1
    
    private var currentGenreID: Int?
    
    func fetchManga(for genreID: Int) async {
        // Reset pagination when fetching a new genre
        if currentGenreID != genreID {
            currentGenreID = genreID
            currentPage = 1
            hasMorePages = true
            mangaList = []
        }
        
        let urlString = "https://api.jikan.moe/v4/manga?genres=\(genreID)&page=\(currentPage)"
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(MangaResponse.self, from: data)
            
            if currentPage == 1 {
                mangaList = decoded.data
            } else {
                mangaList.append(contentsOf: decoded.data)
            }
            
            hasMorePages = decoded.data.count >= 25
            
        } catch {
            print("Failed to fetch manga base on genre: \(error.localizedDescription)")
        }
    }
    
    func loadMoreIfNeeded(genreID: Int) async {
        guard !isLoadingMore && hasMorePages && currentGenreID == genreID else { return }
        
        isLoadingMore = true
        currentPage += 1
        
        await fetchManga(for: genreID)
        
        isLoadingMore = false
    }
}
