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
    private var articlesToDisplay = [Article]()
    private let total = 15
    
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
            self.articlesToDisplay.removeAll()
            self.appendElements()
            self.delegate?.updateTableView()
        }
    }
    
    func appendElements() {
        let count = articlesToDisplay.count
        let countArticles = articles.count
        var index = 0
        while index < total {
            if count + index < countArticles {
                articlesToDisplay.append(articles[count + index])
            }
            index += 1
        }
    }
    
    func getCount() -> Int {
        return articlesToDisplay.count
    }
    
    func getArticle(at indexPath: IndexPath) -> Article {
        return articlesToDisplay[indexPath.row]
    }
    
    func getArticle(at index: Int) -> Article {
        return articlesToDisplay[index]
    }
    
    func sortArticles() {
        if sortState & 1 == 1 {
            articlesToDisplay = articlesToDisplay.sorted(by: { $0.publishedAt > $1.publishedAt })
            sortState += 1
        } else {
            articlesToDisplay = articlesToDisplay.sorted(by: { $0.publishedAt < $1.publishedAt })
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
