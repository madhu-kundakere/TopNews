//
//  NewsRowView.swift
//  News
//
//  Created by Madhu on 24/01/25.
//

import SwiftUI

struct NewsCellView: View {
    let article: Article
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(article.title)
                .font(Typography.titleFont())
                .foregroundColor(.textPrimary)
                .lineLimit(3)
                .accessibilityLabel("Article title: \(article.title)")
        
            HStack {
                AsyncImage(url: URL(string: article.urlToImage ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                            .scaledToFill()
                            .frame(width: Dimensions.standard, height: Dimensions.standard)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                            .accessibilityLabel("Article image")
                    case .empty, .failure:
                        placeholderImage
                    @unknown default:
                        EmptyView()
                    }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    if let description = article.description {
                        Text(description)
                            .font(Typography.subHeadlineFont())
                            .foregroundColor(.textSecondary)
                            .accessibilityLabel("Description: \(description)")
                           
                    }
                    if let author = article.author {
                        Text("\(Strings.authorPrefix) \(author)")
                            .font(Typography.subHeadlineFont())
                            .lineLimit(1)
                            .foregroundColor(.red)
                            .padding(.top, 4)
                            .accessibilityLabel("Author: \(author)")
                    }
                }
                .padding(.leading, Spacing.medium)
                Spacer()
            }
        }
        .accessibilityLabel("News article row")
    }
}

fileprivate extension NewsCellView {
    var placeholderImage: some View {
        Image(systemName: Strings.placeholderImageName)
            .resizable()
            .scaledToFit()
            .frame(width: Dimensions.standard, height: Dimensions.standard)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
            .foregroundColor(.gray)
    }
}

