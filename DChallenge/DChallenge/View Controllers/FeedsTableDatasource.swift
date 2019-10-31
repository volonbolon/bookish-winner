//
//  FeedsTableDatasource.swift
//  DChallenge
//
//  Created by Ariel Rodriguez on 31/10/2019.
//  Copyright © 2019 Ariel Rodriguez. All rights reserved.
//

import UIKit

class FeedsDatasource: NSObject, UITableViewDataSource {
    private var feeds: [Feed] = []
    @IBOutlet weak var tableView: UITableView!
    let networkManager = NetworkManager()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.identifier, for: indexPath)
        if let feedCell = cell as? FeedTableViewCell {
            let feed = feeds[indexPath.row]
            feedCell.titleLabel.text = feed.title
        }
        return cell
    }

    func appendFeed(feed: Feed) {
        self.feeds.append(feed)
        self.tableView.reloadData()
    }

    func fetchFeeds() {
        networkManager.fetchSubscriptions { (result: Either<NetworkControllerError, NetworkManager.Feeds>) in
            switch result {
            case .right(let feeds):
                DispatchQueue.main.async {
                    self.feeds = feeds
                    self.tableView.reloadData()
                }
            case .left(let error):
                print(error)
            }
        }
    }
}
