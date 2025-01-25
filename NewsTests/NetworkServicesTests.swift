//
//  NetworkServicesTests.swift
//  News
//
//  Created by Madhu on 25/01/25.
//

import XCTest
@testable import News


/// Unit tests for the `NetworkService` class that test fetching news, likes, and comments,
class NetworkServicesTests: XCTestCase {
    var networkService: NetworkService!
    var mockNetworkService: MockNetworkServiceImpl!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkServiceImpl()
        networkService = mockNetworkService
    }

    override func tearDown() {
        networkService = nil
        mockNetworkService = nil
        super.tearDown()
    }

    /// Test case for successfully fetching recent news.
    /// Verifies that the response contains articles and the first article has the correct title.
    func testFetchRecentNews_Success() async {
        let mockArticle = Article(source: Source(id: "1", name: "Example Source"),
                                   author: "John Doe",
                                   title: "Sample News Article",
                                   description: "Description of article",
                                   url: "https://www.example.com",
                                   urlToImage: "https://www.example.com/image.jpg",
                                   publishedAt: "24/01/2025",
                                   content: "Content of the article")
        
        mockNetworkService.mockArticles = [mockArticle]

        do {
            let newsResponse = try await networkService.fetchRecentNews(page: 1)
            XCTAssertEqual(newsResponse.status, "ok")
            XCTAssertEqual(newsResponse.articles.count, 1)
            XCTAssertEqual(newsResponse.articles.first?.title, "Sample News Article")
        } catch {
            XCTFail("Expected successful response, but got error: \(error)")
        }
    }

    /// Test case for failed fetching of recent news.
    /// Simulates an error during the network request and verifies the failure response.
    func testFetchRecentNews_Failure() async {
        mockNetworkService.shouldReturnError = true

        do {
            _ = try await networkService.fetchRecentNews(page: 1)
            XCTFail("Expected failure, but got a successful response")
        } catch {
            XCTAssertEqual((error as NSError).code, 500)
        }
    }

    /// Test case for successfully fetching likes for an article.
    /// Verifies that the correct number of likes is returned.
    func testFetchLikes_Success() async {
        mockNetworkService.mockLikes = 100

        do {
            let likes = try await networkService.fetchLikes(for: "sample-article-id")
            XCTAssertEqual(likes, 100)
        } catch {
            XCTFail("Expected successful response, but got error: \(error)")
        }
    }

    /// Test case for failed fetching of likes.
    /// Simulates an error during the network request and verifies the failure response.
    func testFetchLikes_Failure() async {
        mockNetworkService.shouldReturnError = true

        do {
            _ = try await networkService.fetchLikes(for: "sample-article-id")
            XCTFail("Expected failure, but got a successful response")
        } catch {
            XCTAssertEqual((error as NSError).code, 500)
        }
    }

    /// Test case for successfully fetching comments for an article.
    /// Verifies that the correct number of comments is returned.
    func testFetchComments_Success() async {
        mockNetworkService.mockComments = 50

        do {
            let comments = try await networkService.fetchComments(for: "sample-article-id")
            XCTAssertEqual(comments, 50)
        } catch {
            XCTFail("Expected successful response, but got error: \(error)")
        }
    }

    /// Test case for failed fetching of comments.
    /// Simulates an error during the network request and verifies the failure response.
    func testFetchComments_Failure() async {
        mockNetworkService.shouldReturnError = true

        do {
            _ = try await networkService.fetchComments(for: "sample-article-id")
            XCTFail("Expected failure, but got a successful response")
        } catch {
            XCTAssertEqual((error as NSError).code, 500)
        }
    }
}
