//
//  MockNetworkService.swift
//  News
//
//  Created by Madhu on 25/01/25.
//

import XCTest
@testable import News

// Mocking NetworkServiceProtocol for Unit Testing
class MockNetworkServiceImpl: NetworkService {
    var shouldReturnError = false
    var mockArticles: [Article] = []
    var mockLikes: Int = 10
    var mockComments: Int = 5
    
    // Mocking fetchRecentNews
    func fetchRecentNews(page: Int) async throws -> NewsResponse {
        if shouldReturnError {
            throw NSError(domain: "NetworkError", code: 500, userInfo: nil)
        }
        let status = "ok"  // or use any status you want
        let totalResults = 1  // You can set this to the count of mock articles
        
        return NewsResponse(status: status, totalResults: totalResults, articles: mockArticles)
    }
    
    // Mocking fetchLikes
    func fetchLikes(for articleID: String) async throws -> Int {
        if shouldReturnError {
            throw NSError(domain: "NetworkError", code: 500, userInfo: nil)
        }
        return mockLikes
    }
    
    // Mocking fetchComments
    func fetchComments(for articleID: String) async throws -> Int {
        if shouldReturnError {
            throw NSError(domain: "NetworkError", code: 500, userInfo: nil)
        }
        return mockComments
    }
}
