//
//  TopMangaViewModel.swift
//  JikanAPP
//
//  Created by stolenfallen1 on 7/23/25.
//

import Foundation

@MainActor
class TopMangaViewModel: ObservableObject, InfiniteLoadingViewModel {
    @Published var topMangaList: [Manga] = []
    @Published var isLoadingMore: Bool = false
    @Published var hasMorePages: Bool = true
    @Published var currentPage: Int = 1
    
    private var isInitialLoad = true
    
    func fetchTopManga() async {
        if isInitialLoad {
            currentPage = 1
            hasMorePages = true
            topMangaList = []
            isInitialLoad = false
        }
        
        let urlString = "https://api.jikan.moe/v4/top/manga?page=\(currentPage)"
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(MangaResponse.self, from: data)
            
            if currentPage == 1 {
                topMangaList = decoded.data
            } else {
                topMangaList.append(contentsOf: decoded.data)
            }
            
            hasMorePages = decoded.data.count >= 25
            
        } catch {
            print("Failed to fetch top manga: \(error.localizedDescription)")
        }
    }
    
    func loadMoreIfNeeded() async {
        guard !isLoadingMore && hasMorePages else { return }
        
        isLoadingMore = true
        currentPage += 1
        
        await fetchTopManga()
        
        isLoadingMore = false
    }
}
