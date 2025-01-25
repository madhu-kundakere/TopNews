//
//  NewsApp.swift
//  News
//
//  Created by Madhu on 24/01/25.
//

import SwiftUI

@main
struct NewsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NewsListView()
        }
    }
}
