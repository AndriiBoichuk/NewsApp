//
//  AnswerManager.swift
//  NewsApp
//
//  Created by Андрій Бойчук on 06.01.2022.
//

import Foundation
import Alamofire

class AnswerManager {
    
    private let queue = DispatchQueue.global(qos: .default)
    private let dispatchGroup = DispatchGroup()
    private let apiKey = "236e1a7771c44c54816114ec19b93c64"
    private let url = "https://newsapi.org/v2/everything?q="
    
    func getRequest(at word: String, completion: @escaping (News?) -> ()) {
        let urlRequest = url + word + "&apiKey=" + apiKey
        var news: News?
        dispatchGroup.enter()
        AF.request(urlRequest).responseDecodable(of: News.self) { response in
            guard let receivedNews = response.value else { return }
            news = receivedNews
            self.dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            completion(news)
        }
    }
    
}
