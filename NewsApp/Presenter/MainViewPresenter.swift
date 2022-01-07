//
//  MainViewPresenter.swift
//  NewsApp
//
//  Created by Андрій Бойчук on 06.01.2022.
//

import Foundation

class MainViewPresenter {
    
    private var articles = [Article]()
    private var answerManager: AnswerManager
    private var sortState = 0
    
    var delegate: MainVCDelegate?
    
    init(_ answerManager: AnswerManager) {
        self.answerManager = answerManager
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
    
}
