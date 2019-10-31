//
//  SubscribeViewController.swift
//  DChallenge
//
//  Created by Ariel Rodriguez on 31/10/2019.
//  Copyright © 2019 Ariel Rodriguez. All rights reserved.
//

import UIKit

protocol SubscriptionDelegate: class {
    func subscribedToFeed(_ feed: Feed)
}

class SubscribeViewController: UIViewController {
    @IBOutlet weak var subscriptionTextField: UITextField!

    weak var delegate: SubscriptionDelegate?

    fileprivate let networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func cancel(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }

    @IBAction func subscribe(_ sender: Any) {
        guard let feedURL = subscriptionTextField.text, feedURL.count > 10 else {
            return
        }
        networkManager.subscribeToFeed(feedURL: feedURL) { (result: Either<NetworkControllerError, NetworkManager.Feeds>) in // swiftlint:disable:this line_length

            DispatchQueue.main.async {
                switch result {
                case .left(let error):
                    self.presentAlert(error: error)
                case .right(let feeds):
                    if let feed = feeds.first {
                        self.delegate?.subscribedToFeed(feed)
                    }
                }
            }
            print(result)
        }
    }
}

extension SubscribeViewController { // MARK: - Helpers
    fileprivate func presentAlert(error: Error) {
        let title = NSLocalizedString("Unable to subscribe to feed", comment: "Unable to subscribe to feed")
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        let actionTitle = NSLocalizedString("OK", comment: "OK")
        let action = UIAlertAction(title: actionTitle, style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
