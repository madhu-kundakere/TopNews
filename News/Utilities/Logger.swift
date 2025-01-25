//
//  Logger.swift
//  News
//
//  Created by Madhu on 24/01/25.
//

import Foundation

enum LogLevel: String {
    case debug = "debug"
    case info = "info"
    case warning = "warning"
    case error = "error"
}

struct Logger {
    static func log(_ message: String, level: LogLevel = .info) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
        let logMessage: String

        switch level {
        case .debug:
            logMessage = "[DEBUG] \(timestamp): \(message)"
        case .info:
            logMessage = "[INFO] \(timestamp): \(message)"
        case .warning:
            logMessage = "[WARNING] \(timestamp): \(message)"
        case .error:
            logMessage = "[ERROR] \(timestamp): \(message)"
        }
        
        debugPrint(logMessage)
    }
}
