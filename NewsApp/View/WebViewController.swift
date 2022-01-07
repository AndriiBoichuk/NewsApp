//
//  WebViewController.swift
//  NewsApp
//
//  Created by Андрій Бойчук on 06.01.2022.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    private var webView: WKWebView!
    private let url: URL
    
    init(url: URL, title: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initWebView()
    }
    
    func initWebView() {
        self.webView.load(URLRequest(url: self.url))
    }
    
}
