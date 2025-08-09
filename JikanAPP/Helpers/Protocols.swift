//
//  Protocols.swift
//  JikanAPP
//
//  Created by Jhon Llyod Quizeo on 8/9/25.
//

import Foundation

@MainActor
protocol InfiniteLoadingViewModel: ObservableObject {
    var isLoadingMore: Bool { get }
    var hasMorePages: Bool { get }
    var currentPage: Int { get }
}
