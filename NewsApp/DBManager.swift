//
//  DBManager.swift
//  NewsApp
//
//  Created by Андрій Бойчук on 07.01.2022.
//

import Foundation
import RealmSwift

class DBManager {
    
    private let realm = try! Realm()
    private var articles: Results<ArticleSave>?
    
    func save(article: ArticleSave) {
        do {
            try realm.write{
                realm.add(article)
            }
        } catch {
            print(error)
        }
        print("saved")
//        tableView.reloadData()
    }
    
    func loadArticles() {
        articles = realm.objects(ArticleSave.self)
        print("Loaded")
        // tableView.reloadData()
    }
    
    func deleteArticle(article: ArticleSave) {
        do {
            try realm.write {
                realm.delete(article)
            }
        } catch {
            print(error)
        }
        
        // tableView.reloadData
    }
    
    func getCount() -> Int {
        guard let articles = articles else {
            return 0
        }
        return articles.count
    }
    
    func getArticle(at indexPath: IndexPath) -> ArticleSave {
        guard let articles = articles else {
            return ArticleSave()
        }
        return articles[indexPath.row]
    }
    
}
