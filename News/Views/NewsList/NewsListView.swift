//
//  NewsListView.swift
//  News
//
//  Created by Madhu on 24/01/25.
//

import SwiftUI

private enum Constants {
    static let newsNavigationTitle = "Top Headlines"
    static let favoritesNavigationTitle = "Favorites"
    static let noFavoritesText = "No favorites added yet."
}

struct NewsListView: View {
    @StateObject var viewModel = NewsViewModel()
    
    var body: some View {
        TabView {
            articleListView(isFavorite: false)
                .tabItem {
                    Image(systemName: "newspaper.fill")
                    Text("News")
                }
            
            articleListView(isFavorite: true)
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Favorites")
                }
        }
    }
    
    @ViewBuilder
    private func articleListView(isFavorite: Bool) -> some View {
        NavigationView {
            VStack {
                let filteredArticles = isFavorite ? viewModel.articles.filter { $0.isFavorite } : viewModel.articles
                if filteredArticles.isEmpty {
                    if isFavorite {
                        Text(Constants.noFavoritesText)
                            .font(Typography.titleFont())
                            .foregroundColor(.textPrimary)
                            .padding()
                    } else {
                        ProgressView()
                            .padding()
                            .onAppear {
                                viewModel.loadRecentNews()
                            }
                    }
                } else {
                    List {
                        ForEach(filteredArticles) { article in
                            NavigationLink(destination: NewsDetailView(viewModel: viewModel, article: article)) {
                                HStack {
                                    NewsCellView(article: article)
                                }
                            }
                        }
                        if !isFavorite && viewModel.hasMoreData {
                            ProgressView()
                                .padding()
                                .onAppear {
                                    viewModel.loadRecentNews()
                                }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle(isFavorite ? Constants.favoritesNavigationTitle : Constants.newsNavigationTitle)
        }
    }
}

#Preview {
    NewsListView()
}
