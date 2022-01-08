//
//  ArticlesViewPresenter.swift
//  NewsApp
//
//  Created by Андрій Бойчук on 07.01.2022.
//

import Foundation

class ArticlesViewPresenter {
    
    private let dbManager: DBManager
    var delegate: UpdatingDelegate?
    
    init(dbManager: DBManager) {
        self.dbManager = dbManager
    }
    
    func loadArticles() {
        dbManager.loadArticles()
        delegate?.updateTableView()
    }
    
    func getCount() -> Int {
        return dbManager.getCount()
    }
    
    func getArticle(at indexPath: IndexPath) -> ArticleSave {
        return dbManager.getArticle(at: indexPath)
    }
    
}
