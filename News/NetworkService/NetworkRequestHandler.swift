//
//  NetworkRequestHandler.swift
//  News
//
//  Created by Madhu on 24/01/25.
//

import Foundation

// MARK: - Network Request Handler
class NetworkRequestHandler {
    static let shared = NetworkRequestHandler()
    
    func request<T: Decodable>(_ urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            Logger.log("Invalid URL: \(urlString)", level: .error)
            throw NetworkError.nonValidUrl
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            Logger.log("Failed to decode: \(error.localizedDescription)", level: .error)
            throw NetworkError.failedToDecode
        }
    }
}
