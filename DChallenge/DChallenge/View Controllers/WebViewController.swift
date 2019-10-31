//
//  WebViewController.swift
//  DChallenge
//
//  Created by Ariel Rodriguez on 31/10/2019.
//  Copyright © 2019 Ariel Rodriguez. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!

    var article: Article!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = article.title

        let request = URLRequest(url: article.url)
        webView.load(request)
    }
}
