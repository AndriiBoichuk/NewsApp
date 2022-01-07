//
//  ViewController.swift
//  NewsApp
//
//  Created by Андрій Бойчук on 05.01.2022.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

    private let navBarView = UIView()
    private let label = UILabel()
    private let sortButton = UIButton()
    private let filterButton = UIButton()
    private let searchController = UISearchController()
    private let favouriteButton = UIButton()
    private let tableView = UITableView()
    private let presenter: MainViewPresenter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "News app"
        
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        presenter.delegate = self
        initNavBar()
        initTableView()
        presenter.getNews(at: "Example")
    }
    
    init(presenter: MainViewPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func sortButtonTapped(_ sender: UIButton) {
        let startTransform = sender.transform
        UIView.animate(withDuration: 0.5, delay: 0, options: [ .autoreverse, .allowUserInteraction], animations: {
            sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, completion: { finished in
                sender.transform = startTransform
        })
        presenter.sortArticles()

    }
    
    @objc func filterButtonTapped(_ sender: UIButton) {
        let startTransform = sender.transform
        UIView.animate(withDuration: 0.5, delay: 0, options: [ .autoreverse, .allowUserInteraction], animations: {
            sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, completion: { finished in
                sender.transform = startTransform
        })
    }
    
    @objc func favouriteButtonTapped(_ sender: UIButton) {
        let startTransform = sender.transform
        UIView.animate(withDuration: 0.5, delay: 0, options: [ .autoreverse, .allowUserInteraction], animations: {
            sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, completion: { finished in
                sender.transform = startTransform
        })
    }
    
    @objc func addArticleToFavourite(_ sender: UIButton) {
        sender.rotate()
        sender.alpha = 0.5
        UIView.animate(withDuration: 0.5, delay: 1, options: .curveEaseOut) {
            sender.alpha = 1
            sender.setImage(UIImage(systemName: "seal.fill"), for: .normal)
        } completion: { finished in
            UIView.animate(withDuration: 0.5, delay: 1, options: .curveEaseOut, animations: {
                sender.setImage(UIImage(systemName: "seal"), for: .normal)
            }, completion: nil)
        }

    }
    
    func initNavBar() {
        view.backgroundColor = .white
        
        let sortImage = UIImage(systemName: "arrow.up.arrow.down.square")
        sortButton.setBackgroundImage(sortImage, for: .normal)
        sortButton.frame = CGRect(x: 0, y: 0, width: 34, height: 30)
        sortButton.tintColor = .label
        sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        
        let filterImage = UIImage(systemName: "line.3.horizontal.decrease.circle")
        filterButton.setBackgroundImage(filterImage, for: .normal)
        filterButton.frame = CGRect(x: 0, y: 0, width: 32, height: 30)
        filterButton.tintColor = .label
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        let favouriteImage = UIImage(systemName: "seal")
        favouriteButton.setBackgroundImage(favouriteImage, for: .normal)
        favouriteButton.frame = CGRect(x: 0, y: 0, width: 32, height: 30)
        favouriteButton.tintColor = .label
        favouriteButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        
        navigationItem.searchController = searchController
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: sortButton), UIBarButtonItem(customView: filterButton)]
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: favouriteButton)
    }
    
    func initTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let cell = UINib(nibName: "CustomTableViewCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "CustomCell")
        tableView.dataSource = self
        tableView.delegate = self

    }
}

// MARK: - Search Results Updating

extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else{ return }
        print(text)
    }
    
}

// MARK: - Search Controller Delegate

extension MainViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            presenter.getNews(at: text)
        }
    }
    
}

// MARK: - Data Source, Table View Delegate

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        let article = presenter.getArticle(at: indexPath)
        cell.titleLabel.text = article.title
        cell.authorLabel.text = article.author
        cell.sourceLabel.text = article.source.name
        cell.descriptionLabel.text = article.description
        DispatchQueue.global(qos: .userInitiated).async {
            if let safeUrl = article.urlToImage {
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
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = presenter.getArticle(at: indexPath)
        guard let url = URL(string: article.url) else { return }
        let webVC = WebViewController(url: url, title: article.title)
        navigationController?.pushViewController(webVC, animated: true)
    }
    
}

// MARK: - Custom Cell Delegate

extension MainViewController: CustomCellDelegate {

    func addArticleTapped() {
        tableView.reloadData()
    }

}

// MARK: - Delegate for updating tableview

extension MainViewController: MainVCDelegate {
    
    func updateTableView() {
        tableView.reloadData()
    }
    
}

extension UIView{
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1.2
        rotation.isCumulative = true
        rotation.repeatCount = 1
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}
