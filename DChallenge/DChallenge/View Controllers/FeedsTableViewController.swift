//
//  FeedsTableViewController.swift
//  DChallenge
//
//  Created by Ariel Rodriguez on 31/10/2019.
//  Copyright © 2019 Ariel Rodriguez. All rights reserved.
//

import UIKit

class FeedsTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        guard !presentAuthenticationViewControllerIfNeeded() else {
            return
        }

        if let datasource = tableView.dataSource as? FeedsDatasource {
            datasource.fetchFeeds()
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifier = segue.identifier else {
            return
        }
        switch segueIdentifier {
        case Constants.StoryboardsIdentifiers.ShowSubscriptionSheet:
            if let destination = segue.destination as? SubscribeViewController {
                destination.delegate = self
            }
        case Constants.StoryboardsIdentifiers.ShowArticles:
            if let destination = segue.destination as? ArticlesTableViewController,
                let selectedIndexPath = self.tableView.indexPathForSelectedRow,
                let datasource = tableView.dataSource as? FeedsDatasource {
                let feed = datasource.feedAtIndex(indexPath: selectedIndexPath)
                destination.feed = feed
            }
        default:
            print("Unknown Segue")
        }
    }
}

extension FeedsTableViewController: SubscriptionDelegate {
    func subscribedToFeed(_ feed: Feed) {
        if let datasource = tableView.dataSource as? FeedsDatasource {
            datasource.appendFeed(feed: feed)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension FeedsTableViewController { // MARK: - Helpers
    /**
        returns false if user is already authenticated
     */
    fileprivate func presentAuthenticationViewControllerIfNeeded() -> Bool {
        let sud = UserDefaults.standard
        guard sud.object(forKey: Constants.UserDefaultsKeys.AuthToken) == nil else {
            return false
        }

        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        if let authenticationViewController = storyboard.instantiateInitialViewController() as? AuthenticationViewController { // swiftlint:disable:this line_length
            authenticationViewController.delegate = self
            authenticationViewController.modalPresentationStyle = .currentContext
            parent?.present(authenticationViewController, animated: true, completion: nil)
        }
        return true
    }
}

extension FeedsTableViewController: AuthenticationDelegate {
    func userSuccessfullyAuthenticated() {
        dismiss(animated: true, completion: nil)
        if let datasource = tableView.dataSource as? FeedsDatasource {
            datasource.fetchFeeds()
        }
    }
}
