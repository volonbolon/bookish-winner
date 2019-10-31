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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifier = segue.identifier else {
            return
        }
        switch segueIdentifier {
        case Constants.StoryboardsIdentifiers.ShowArticle:
            if let destination = segue.destination as? WebViewController,
                let selectedIndexPath = self.tableView.indexPathForSelectedRow,
                let datasource = tableView.dataSource as? ArticlesDatasource {
                let article = datasource.articleAtIndex(selectedIndexPath)
                destination.article = article
            }
        default:
            print("Unknown Segue")
        }
    }
}
