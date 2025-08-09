//
//  TopAnimeViewModel.swift
//  JikanAPP
//
//  Created by stolenfallen1 on 7/23/25.
//

import Foundation

@MainActor
class TopAnimeViewModel: ObservableObject, InfiniteLoadingViewModel {
    @Published var topAnimeList: [Anime] = []
    @Published var isLoadingMore: Bool = false
    @Published var hasMorePages: Bool = true
    @Published var currentPage: Int = 1
    
    private var isInitialLoad = true
    
    func fetchTopAnime() async {
        if isInitialLoad {
            currentPage = 1
            hasMorePages = true
            topAnimeList = []
            isInitialLoad = false
        }
        
        let urlString = "https://api.jikan.moe/v4/top/anime?page=\(currentPage)"
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(AnimeResponse.self, from: data)
            
            if currentPage == 1 {
                topAnimeList = decoded.data
            } else {
                topAnimeList.append(contentsOf: decoded.data)
            }
            
            hasMorePages = decoded.data.count >= 25
            
        } catch {
            print("Failed to fetch anime: \(error.localizedDescription)")
        }
    }
    
    func loadMoreIfNeeded() async {
        guard !isLoadingMore && hasMorePages else { return }
        
        isLoadingMore = true
        currentPage += 1
        
        await fetchTopAnime()
        
        isLoadingMore = false
    }
}
