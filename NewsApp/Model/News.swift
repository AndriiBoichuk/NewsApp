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
