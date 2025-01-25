//
//  NewsViewModelTests.swift
//  News
//
//  Created by Madhu on 25/01/25.
//

import XCTest
@testable import News

class NewsViewModelTests: XCTestCase {

    var viewModel: NewsViewModel!
    var mockNetworkService: MockNetworkServiceImpl!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkServiceImpl()
        viewModel = NewsViewModel(networkService: mockNetworkService)
    }

    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        super.tearDown()
    }

    /// Helper method to create a mock `Article` with a given URL for testing purposes.
    /// - Parameter url: The URL string for the mock article.
    /// - Returns: A mock `Article` object
    func createMockArticle(url: String) -> Article {
        let source = Source(id: "1", name: "Example Source")
        return Article(
            source: source,
            author: "John Doe",
            title: "Sample Article",
            description: "Sample description",
            url: url,
            urlToImage: "https://www.example.com/image.jpg",
            publishedAt: "24/01/2025",
            content: "Sample content"
        )
    }
    
    /// Test case for toggling the favorite status of an article.
    /// Verifies that the article's `isFavorite` status toggles correctly and that the `favoriteArticles` returns the correct filtered list.
    func testToggleFavorite() {
        // Create a mock article
        var article = createMockArticle(url: "https://www.example.com/article")
        article.isFavorite = false
        
   
        viewModel.articles.append(article)
        
        // Verify the initial state
        XCTAssertEqual(viewModel.favoriteArticles.count, 0)
        
        // Toggle the favorite status of the article
        viewModel.toggleFavorite(for: article)
        
        XCTAssertTrue(viewModel.articles[0].isFavorite)
        XCTAssertEqual(viewModel.favoriteArticles.count, 1)
        
        viewModel.toggleFavorite(for: article)
        
        XCTAssertFalse(viewModel.articles[0].isFavorite)
        XCTAssertEqual(viewModel.favoriteArticles.count, 0)
    }

    /// Test case for successful loading of recent news from the network.
    /// Verifies that the viewModel's `articles` array is populated and `hasMoreData` is set to true.
    func testLoadRecentNews_Success() async {
        let mockArticle = createMockArticle(url: "https://www.example.com/article")
        
        mockNetworkService.mockArticles = [mockArticle]
        
        viewModel.loadRecentNews()

        XCTAssertNotNil(viewModel.articles)
        XCTAssertTrue(viewModel.hasMoreData)
        XCTAssertNil(viewModel.errorMessage)
    }

    /// Test case for failed loading of recent news.
    /// Simulates a network failure and verifies that the `articles` array is empty.
    func testLoadRecentNews_Failure() async {
        mockNetworkService.shouldReturnError = true
        
        viewModel.loadRecentNews()

        XCTAssertEqual(viewModel.articles.count, 0)
    }

    /// Test case for fetching article details (likes and comments) successfully.
    /// Verifies that the likes and comments are properly fetched and stored in the viewModel.
    func testFetchArticleDetails_Success() async {
        let article = createMockArticle(url: "https://www.example.com/article")
        
        mockNetworkService.mockLikes = 100
        mockNetworkService.mockComments = 50

        await viewModel.fetchArticleDetails(for: article)

        XCTAssertEqual(viewModel.likes["www.example.com-article"], 100)
        XCTAssertEqual(viewModel.comments["www.example.com-article"], 50)
    }

    /// Test case for failed fetching of article details (likes and comments).
    /// Simulates a network error and ensures that no likes or comments are fetched.
    func testFetchArticleDetails_Failure() async {
        mockNetworkService.shouldReturnError = true
        let article = createMockArticle(url: "https://www.example.com/article")

        await viewModel.fetchArticleDetails(for: article)

        // Assert
        XCTAssertNil(viewModel.likes["www.example.com-article"])
        XCTAssertNil(viewModel.comments["www.example.com-article"])
    }

    /// Test case for generating a valid article ID from the article URL.
    /// Verifies that the article URL is correctly converted to a valid ID.
    func testGenerateArticleID() {
        let article = createMockArticle(url: "https://www.example.com/article")
        let articleID = viewModel.generateArticleID(from: article.url)

        // Assert
        XCTAssertNotNil(articleID)
        XCTAssertEqual(articleID, "www.example.com-article")
    }

    /// Test case for handling invalid article URLs when generating article IDs.
    /// Verifies that `nil` is returned if the URL is invalid.
    func testGenerateArticleID_InvalidURL() {
        let article = createMockArticle(url: "invalid-url")
        let articleID = viewModel.generateArticleID(from: article.url)

        // Assert
        XCTAssertNil(articleID)
    }
}
