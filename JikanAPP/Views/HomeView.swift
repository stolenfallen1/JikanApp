//
//  HomeView.swift
//  JikanAPP
//
//  Created by stolenfallen1 on 7/22/25.
//

import SwiftUI

struct FeaturedContent {
    let title: String
    let type: ContentType
    let rating: Double
    let year: String
    let description: String
}

enum ContentType {
    case anime, manga
    
    var displayName: String {
        switch self {
            case .anime: return "ANIME"
            case .manga: return "MANGA"
        }
    }
}

struct HomeView: View {
    @State private var currentImageIndex = 0
    @State private var searchText = ""
    @State private var orientation = UIDeviceOrientation.unknown // Orientation state
    
    // Computed property to check if user device is phone
    private var isPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
    
    // Computed property to check device orientation
    private var isLandscape: Bool {
        orientation.isLandscape
    }
    
    private var shouldHideNavigationCards: Bool {
        isLandscape && isPhone
    }
    
    private
    
    let featuredContent = [
        FeaturedContent(title: "Attack on Titan", type: .anime, rating: 9.0, year: "2013", description: "Humanity fights for survival against giant Titans"),
        FeaturedContent(title: "One Piece", type: .manga, rating: 9.2, year: "1997", description: "A pirate's adventure to find the legendary treasure"),
        FeaturedContent(title: "Demon Slayer", type: .anime, rating: 8.7, year: "2019", description: "A young boy becomes a demon slayer")
    ]
    
    var currentFeatured: FeaturedContent {
        featuredContent[currentImageIndex]
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                HeroImageView(imageName: currentFeatured.title)
                    .ignoresSafeArea()
                
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.2),
                        Color.black.opacity(0.6),
                        Color.black.opacity(0.9)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack {
                    VStack(spacing: 20) {
                        // App title row
                        HStack {
                            Text("OtakuHaven")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Image(systemName: "person.circle.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                            }
                        }
                        
                        // Search bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            
                            TextField("Search anime or manga...", text:$searchText)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    ScrollView(showsIndicators: false) {
                        VStack {
                            Spacer()
                                .frame(height: 20)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text(currentFeatured.type.displayName)
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(currentFeatured.type == .anime ? Color.red : Color.blue)
                                        .cornerRadius(16)
                                    
                                    Spacer()
                                    
                                    // Rating
                                    HStack(spacing: 4) {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.yellow)
                                            .font(.caption)
                                        Text(String(format: "%.1f", currentFeatured.rating))
                                            .foregroundColor(.white)
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                    }
                                }
                                
                                Text(currentFeatured.title)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text(currentFeatured.year)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                Text(currentFeatured.description)
                                    .font(.body)
                                    .foregroundColor(.white.opacity(0.9))
                                    .lineLimit(2)
                                
                                Button(action: {}) {
                                    HStack {
                                        Text("View Details")
                                            .fontWeight(.semibold)
                                        Image(systemName: "arrow.right")
                                    }
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(20)
                                }
                                .padding(.top)
                            }
                            .padding(.horizontal)
                            
                            if shouldHideNavigationCards {
                                VStack(spacing: 20) {
                                    Spacer()
                                        .frame(height: 30)
                                    
                                    HStack(spacing: 10) {
                                        NavigationLink(destination: AnimeView()) {
                                            NavigationCard(title: "Browse Anime", icon: "tv.fill", color: .red)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        
                                        NavigationLink(destination: MangaView()) {
                                            NavigationCard(title: "Browse Manga", icon: "book.fill", color: .blue)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    // Navigation buttons fixed at the bottom for portrait only
                    if !shouldHideNavigationCards {
                        VStack(spacing: 10) {
                            HStack(spacing: 10) {
                                NavigationLink(destination: AnimeView()) {
                                    NavigationCard(title: "Browse Anime", icon: "tv.fill", color: .red)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                NavigationLink(destination: MangaView()) {
                                    NavigationCard(title: "Browse Manga", icon: "book.fill", color: .blue)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                }
            }
            .onAppear {
                orientation = UIDevice.current.orientation
                startAutoRotation()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                orientation = UIDevice.current.orientation
            }
            .navigationBarHidden(true)
        }
    }
    
    private func startAutoRotation() {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.8)) {
                currentImageIndex = (currentImageIndex + 1) % featuredContent.count
            }
        }
    }
}

struct NavigationCard: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: 200)
        .background(Color.black.opacity(0.4))
        .cornerRadius(16)
    }
}

struct HeroImageView: View {
    let imageName: String
    
    var body: some View {
        Rectangle()
            .fill(gradientForImage(imageName))
    }
    
    private func gradientForImage(_ name: String) -> LinearGradient {
        switch name {
        case "Attack on Titan":
            return LinearGradient(colors: [Color.red.opacity(0.8), Color.black.opacity(0.6)], startPoint: .top, endPoint: .bottom)
        case "One Piece":
            return LinearGradient(colors: [Color.blue.opacity(0.8), Color.orange.opacity(0.6)], startPoint: .top, endPoint: .bottom)
        case "Demon Slayer":
            return LinearGradient(colors: [Color.purple.opacity(0.8), Color.pink.opacity(0.6)], startPoint: .top, endPoint: .bottom)
        default:
            return LinearGradient(colors: [Color.gray.opacity(0.8), Color.black.opacity(0.6)], startPoint: .top, endPoint: .bottom)
        }
    }
}

#Preview {
//    HomeView()
}
