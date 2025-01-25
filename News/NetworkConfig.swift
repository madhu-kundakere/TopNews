//
//  NetworkConfig.swift
//  News
//
//  Created by Madhu on 24/01/25.
//

import Foundation

struct NetworkConfig {
    static let baseURL = "https://newsapi.org/v2/"
    static let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") ?? ""
    
    enum Endpoint {
        case topHeadlines(country: String, pageSize: Int, page: Int)
        case likes(articleID: String)
        case comments(articleID: String)
        
        var urlString: String {
            switch self {
            case .topHeadlines(let country, let pageSize, let page):
                return "\(NetworkConfig.baseURL)top-headlines?country=\(country)&pageSize=\(pageSize)&page=\(page)&apiKey=\(NetworkConfig.apiKey)"
            case .likes(let articleID):
                return "https://cn-news-info-api.herokuapp.com/likes/\(articleID)"
            case .comments(let articleID):
                return "https://cn-news-info-api.herokuapp.com/comments/\(articleID)"
            }
        }
    }
}
