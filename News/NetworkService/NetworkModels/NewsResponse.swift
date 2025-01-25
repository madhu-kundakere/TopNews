//
//  NewsResponse.swift
//  News
//
//  Created by Mahadev on 24/01/25.
//

import Foundation

struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable, Identifiable {
    let id = UUID()
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    var isFavorite: Bool = false 

    enum CodingKeys: String, CodingKey {
        case source
        case author
        case title
        case description
        case url
        case urlToImage
        case publishedAt
        case content
        
    }

//    static let dateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//        return formatter
//    }()
//
//    // Custom decoding logic to handle the date
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        source = try container.decode(Source.self, forKey: .source)
//        author = try container.decodeIfPresent(String.self, forKey: .author)
//        title = try container.decode(String.self, forKey: .title)
//        description = try container.decodeIfPresent(String.self, forKey: .description)
//        url = try container.decode(String.self, forKey: .url)
//        urlToImage = try container.decodeIfPresent(String.self, forKey: .urlToImage)
//        content = try container.decodeIfPresent(String.self, forKey: .content)
//
//        let publishedAtString = try container.decode(String.self, forKey: .publishedAt)
//        if let date = Article.dateFormatter.date(from: publishedAtString) {
//            publishedAt = date
//        } else {
//            throw DecodingError.dataCorruptedError(forKey: .publishedAt, in: container, debugDescription: "Date string does not match expected format")
//        }
//    }
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String
}
