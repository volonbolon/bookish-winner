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

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

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
        if let authenticationViewController = storyboard.instantiateInitialViewController() as? AuthenticationViewController {
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
