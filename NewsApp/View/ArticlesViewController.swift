//
//  ArticlesViewController.swift
//  NewsApp
//
//  Created by Андрій Бойчук on 07.01.2022.
//

import UIKit
import SnapKit

class ArticlesViewController: UIViewController {
    
    private let tableView = UITableView()
    private let presenter: ArticlesViewPresenter
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(Thread.current)
        presenter.delegate = self
        presenter.loadArticles()
        initTableView()
        initNavBar()
    }
    
    init(presenter: ArticlesViewPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let cell = UINib(nibName: "CustomTableViewCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "CustomCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func initNavBar() {
        title = "Favourite articles"
    }
    
    @objc func addArticleToFavourite(_ sender: UIButton) {
        
    }

}

extension ArticlesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        let article = presenter.getArticle(at: indexPath)
        cell.titleLabel.text = article.title
        cell.authorLabel.text = article.author
        cell.sourceLabel.text = article.source
        cell.descriptionLabel.text = article.detail
        let imageToUrl = article.urlToImage
        DispatchQueue.global(qos: .userInitiated).async {
            if let safeUrl = imageToUrl {
                let url = URL(string: safeUrl)!
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        cell.imageURL.image = UIImage(data: data)
                        cell.imageURL.layer.cornerRadius = cell.imageURL.frame.height / 8
                    }
                }
            } else {
                DispatchQueue.main.async {
                    cell.imageURL.isHidden = true
                }
            }
        }
        cell.favouriteButton.addTarget(self, action: #selector(addArticleToFavourite), for: .touchUpInside)
        cell.favouriteButton.tag = indexPath.row
        cell.favouriteButton.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        presenter.deleteArticle(at: indexPath)
    }
    
}

// MARK: - Delegate for updating tableview

extension ArticlesViewController: UpdatingDelegate {

    func updateTableView() {
        tableView.reloadData()
    }
    
}
