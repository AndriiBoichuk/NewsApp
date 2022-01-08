//
//  MainViewPresenter.swift
//  NewsApp
//
//  Created by Андрій Бойчук on 06.01.2022.
//

import Foundation

class MainViewPresenter {
    
    private var articles = [Article]()
    private let answerManager: AnswerManager
    private let dbManager: DBManager
    private var sortState = 0
    
    var delegate: UpdatingDelegate?
    
    init(_ answerManager: AnswerManager, _ dbManager: DBManager) {
        self.answerManager = answerManager
        self.dbManager = dbManager
    }
    
    func getNews(at word: String) {
        answerManager.getRequest(at: word) { news in
            guard let news = news else { return }
            self.articles.removeAll()
            self.articles = news.articles
            self.delegate?.updateTableView()
        }
    }
    
    func getCount() -> Int {
        return articles.count
    }
    
    func getArticle(at indexPath: IndexPath) -> Article {
        return articles[indexPath.row]
    }
    
    func getArticle(at index: Int) -> Article {
        return articles[index]
    }
    
    func sortArticles() {
        if sortState & 1 == 1 {
            articles = articles.sorted(by: { $0.publishedAt > $1.publishedAt })
            sortState += 1
        } else {
            articles = articles.sorted(by: { $0.publishedAt < $1.publishedAt })
            sortState += 1
        }
        delegate?.updateTableView()
    }
    
    func addArticle(_ article: ArticleSave) {
        dbManager.save(article: article)
    }
    
    func getDBManager() -> DBManager {
        return dbManager
    }
    
}
