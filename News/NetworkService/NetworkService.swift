//
//  NetworkService.swift
//  News
//
//  Created by Madhu on 24/01/25.
//

import Foundation

protocol NetworkService {
    func fetchRecentNews(page: Int) async throws -> NewsResponse
    func fetchLikes(for articleID: String) async throws -> Int
    func fetchComments(for articleID: String) async throws -> Int
}

// MARK: - Network Services
struct NetworkServicesImpl: NetworkService {
    
    func fetchRecentNews(page: Int) async throws -> NewsResponse {
        let urlString = NetworkConfig.Endpoint.topHeadlines(country: "us", pageSize: 10, page: page).urlString
        return try await NetworkRequestHandler.shared.request(urlString)
    }
    
    func fetchLikes(for articleID: String) async throws -> Int {
        let urlString = NetworkConfig.Endpoint.likes(articleID: articleID).urlString
        return try await fetchIntegerData(from: urlString)
    }
    
    func fetchComments(for articleID: String) async throws -> Int {
        let urlString = NetworkConfig.Endpoint.comments(articleID: articleID).urlString
        return try await fetchIntegerData(from: urlString)
    }
    
    private func fetchIntegerData(from urlString: String) async throws -> Int {
    guard let url = URL(string: urlString) else {
        Logger.log("Invalid URL: \(urlString)", level: .error)
        throw NetworkError.nonValidUrl
    }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        do {
            if let count = try JSONSerialization.jsonObject(with: data, options: []) as? Int {
                Logger.log("Integer data: \(count)", level: .info)
                return count
            } else {
                Logger.log("Failed to parse integer data", level: .error)
                throw NetworkError.failedToDecode
            }
        } catch {
            Logger.log("Failed to decode integer data", level: .error)
            throw NetworkError.failedToDecode
        }
    }
}

// MARK: - Errors
enum NetworkError: Error {
    case nonValidUrl
    case failedToFetch
    case failedToDecode
}

