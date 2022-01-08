//
//  ArticleSave.swift
//  NewsApp
//
//  Created by Андрій Бойчук on 07.01.2022.
//

import Foundation
import RealmSwift

class ArticleSave: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var source: String
    @Persisted var author: String?
    @Persisted var title: String
    @Persisted var detail: String
    @Persisted var url: String
    @Persisted var urlToImage: String?
    @Persisted var publishedAt: String
}
