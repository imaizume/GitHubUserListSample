//
//  WebViewController.swift
//  GitHubUserListSample
//
//  Created by Tomohiro Imaizumi on 2019/08/07.
//  Copyright © 2019 imaizume. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    
    private var webView: WKWebView!
    
    private var url: URL = .init(fileURLWithPath: "")

    init(_ url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func loadView() {
        super.loadView()
        
        let webConfiguration = WKWebViewConfiguration()
        self.webView = WKWebView(frame: .zero, configuration: webConfiguration)
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        self.view = self.webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.load(.init(url: self.url))
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
}
