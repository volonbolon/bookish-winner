//
//  ArticlesTableViewController.swift
//  DChallenge
//
//  Created by Ariel Rodriguez on 31/10/2019.
//  Copyright © 2019 Ariel Rodriguez. All rights reserved.
//

import UIKit

class ArticlesTableViewController: UITableViewController {
    var feed: Feed!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = feed.title

        if let datasource = tableView.dataSource as? ArticlesDatasource {
            datasource.feed = feed
            datasource.fetchArticles()
        }
    }
}
