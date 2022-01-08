//
//  News.swift
//  NewsApp
//
//  Created by Андрій Бойчук on 06.01.2022.
//

import Foundation

struct News: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Decodable {
    let source: Source
    let author: String?
    let title: String
    let description: String
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String
}

struct Source: Decodable {
    let id: String?
    let name: String
}

extension Article {
    func toArticleSave() -> ArticleSave {
        let articleSave = ArticleSave()
        articleSave.source = self.source.name
        articleSave.author = self.author
        articleSave.title = self.title
        articleSave.detail = self.description
        articleSave.url = self.url
        articleSave.urlToImage = self.urlToImage
        articleSave.publishedAt = self.publishedAt
        return articleSave
    }
}
