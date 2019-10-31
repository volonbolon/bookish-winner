//
//  ArticlesDataSource.swift
//  DChallenge
//
//  Created by Ariel Rodriguez on 31/10/2019.
//  Copyright © 2019 Ariel Rodriguez. All rights reserved.
//

import UIKit

class ArticlesDatasource: NSObject, UITableViewDataSource {
    var feed: Feed!
    let networkManager = NetworkManager()
    private var articles: [Article] = []
    @IBOutlet weak var tableView: UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticlesTableViewCell.identifier, for: indexPath)
        if let articlesCell = cell as? ArticlesTableViewCell {
            let article = articles[indexPath.row]
            articlesCell.titleLabel.text = article.title
        }
        return cell
    }

    func fetchArticles() {
        networkManager.fetchArticles(feed: feed) { (result: Either<NetworkControllerError, NetworkManager.Articles>) in
            switch result {
            case .right(let articles):
                DispatchQueue.main.async {
                    self.articles = articles
                    self.tableView.reloadData()
                }
            case .left(let error):
                print(error)
            }
        }
    }
}
