//
//  NewsViewModel.swift
//  News
//
//  Created by Madhu on 24/01/25.
//

import Foundation
import SwiftUI

class NewsViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var likes: [String: Int] = [:]
    @Published var comments: [String: Int] = [:]
    private var currentPage: Int = 1
    var hasMoreData: Bool = true
    
    private let networkService: NetworkService
    
    // Dependency injection for the network service
    init(networkService: NetworkService = NetworkServicesImpl()) {
        self.networkService = networkService
    }
    
    func toggleFavorite(for article: Article) {
        if let index = articles.firstIndex(where: { $0.id == article.id }) {
            articles[index].isFavorite.toggle()
        }
    }

    var favoriteArticles: [Article] {
        articles.filter { $0.isFavorite }
    }
    
    func loadRecentNews() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let response = try await networkService.fetchRecentNews(page: currentPage)
                DispatchQueue.main.async {
                    self.hasMoreData = response.articles.count > 0
                    self.articles.append(contentsOf: response.articles)
                    self.currentPage += 1
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load news: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
    
    func fetchArticleDetails(for article: Article) async {
        guard let articleID = generateArticleID(from: article.url) else {
            Logger.log("Invalid article URL", level: .error)
            return
        }

        do {
            async let likes = networkService.fetchLikes(for: articleID)
            async let comments = networkService.fetchComments(for: articleID)

            let (fetchedLikes, fetchedComments) = try await (likes, comments)

            self.likes[articleID] = fetchedLikes
            self.comments[articleID] = fetchedComments
        } catch {
            Logger.log("Failed to fetch article details: \(error)", level: .error)
        }
    }

    /// Generates a unique article ID from the article URL.
     func generateArticleID(from urlString: String) -> String? {
        guard let url = URL(string: urlString) else { return nil }
        return url.host.map { $0 + url.path.replacingOccurrences(of: "/", with: "-") }
    }
}
