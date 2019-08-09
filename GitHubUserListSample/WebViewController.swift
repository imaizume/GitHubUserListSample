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

    private var estimatedProgressObserver: NSKeyValueObservation?

    private let progressView: UIProgressView = .init(progressViewStyle: .bar)

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

        guard let navigationBar = self.navigationController?.navigationBar else { return }
        self.progressView.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.addSubview(self.progressView)
        self.progressView.isHidden = true

        NSLayoutConstraint.activate([
            self.progressView.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor),
            self.progressView.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor),
            self.progressView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            self.progressView.heightAnchor.constraint(equalToConstant: 2.0)
        ])

        self.estimatedProgressObserver = self.webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            self?.progressView.progress = Float(webView.estimatedProgress)
        }

    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.progressView.isHidden = false
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.progressView.isHidden = true
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
}
