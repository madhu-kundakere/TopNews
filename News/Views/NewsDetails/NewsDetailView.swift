//
//  NewsDetailView.swift
//  News
//
//  Created by Madhu on 24/01/25.
//

import SwiftUI

private enum Constants {
    static let title = "Article Detail"
    static let likes = "Likes:"
    static let comments = "Comments:"
    static let readFullArticle = "Read full article"
}

struct NewsDetailView: View {
    @ObservedObject var viewModel: NewsViewModel
    let article: Article
    @State private var isBookmarked = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                titleView
                authorView
                imageView
                descriptionView
                likesAndCommentsView
                readFullArticleButton
            }
            .padding()
        }
        .onAppear {
            Task {
                await viewModel.fetchArticleDetails(for: article)
            }
        }
        .navigationTitle(Constants.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isBookmarked.toggle()
                    if isBookmarked {
                        viewModel.toggleFavorite(for: article)
                    }
                }) {
                    Image(systemName: article.isFavorite ? "bookmark.fill" : "bookmark")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

private extension NewsDetailView {
    var titleView: some View {
        Text(article.title)
            .font(Typography.titleFont())
            .padding(.bottom, Spacing.medium)
    }
    
    var authorView: some View {
        Group {
            if let author = article.author {
                Text("By \(author)")
                    .font(Typography.subHeadlineFont())
                    .foregroundColor(.textPrimary)
                    .padding(.bottom, Spacing.medium)
            }
        }
    }
    
    var imageView: some View {
        Group {
            if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: Dimensions.large)
                    case .success(let image):
                        image.resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: Dimensions.large)
                    case .failure:
                        placeholderImage
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                placeholderImage
            }
        }
    }
    
    var placeholderImage: some View {
        Image(systemName: Strings.placeholderImageName)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: Dimensions.large)
    }
    
    var descriptionView: some View {
        Group {
            if let description = article.description {
                Text(description)
                    .font(Typography.subHeadlineFont())
                    .foregroundColor(.textSecondary)
                    .padding(.top, Spacing.medium)
            }
        }
    }
    
    var likesAndCommentsView: some View {
        Group {
            if let articleID = viewModel.generateArticleID(from: article.url) {
                Divider()
                HStack {
                    Text("\(Constants.likes) \(viewModel.likes[articleID] ?? 0)")
                        .font(Typography.subHeadlineFont())
                        .padding(.top, Spacing.small)
                    
                    Text("\(Constants.comments) \(viewModel.comments[articleID] ?? 0)")
                        .font(Typography.subHeadlineFont())
                        .padding(.top, Spacing.small)
                }
                Divider()
            }
        }
    }
    
    var readFullArticleButton: some View {
        Button(action: {
            if let url = URL(string: article.url) {
                UIApplication.shared.open(url)
            }
        }) {
            Text(Constants.readFullArticle)
                .foregroundColor(.blue)
                .padding(.top, Spacing.medium)
        }
    }
}
