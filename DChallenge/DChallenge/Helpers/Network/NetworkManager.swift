//
//  NetworkManager.swift
//  DChallenge
//
//  Created by Ariel Rodriguez on 31/10/2019.
//  Copyright © 2019 Ariel Rodriguez. All rights reserved.
//

import Foundation

class NetworkManager {
    private let session: NetworkSession // here we can insert our own custom session
    typealias Feeds = [Feed]
    typealias FeedsCompletionHandler = (Either<NetworkControllerError, Feeds>) -> Void

    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }

    func deleteFeed(feed: Feed, completionHandler: @escaping FeedsCompletionHandler) {
        let sud = UserDefaults.standard
        let urlString = URLConstants.Feeds.Delete
        guard let token = sud.object(forKey: Constants.UserDefaultsKeys.AuthToken) else {
            let error = NetworkControllerError.invalidURL(urlString)
            let payload = Either<NetworkControllerError, Feeds>.left(error)
            completionHandler(payload)

            return
        }

        let urlWithId = urlString + String(feed.feedId)
        guard let url = URL(string: urlWithId) else {
            let error = NetworkControllerError.invalidURL(urlString)
            let payload = Either<NetworkControllerError, Feeds>.left(error)
            completionHandler(payload)

            return
        }

        var request = URLRequest(url: url)
        let bearer = "Bearer \(token)"
        request.addValue(bearer, forHTTPHeaderField: "Authorization")
        request.httpMethod = HTTPVerbs.DELETE

        session.delete(request: request) { (error: NetworkControllerError?) in
            if error != nil {
                let errorPayload = Either<NetworkControllerError, Feeds>.left(error!)
                completionHandler(errorPayload)
            }
        }
    }

    func fetchSubscriptions(completionHandler: @escaping FeedsCompletionHandler) {
        let sud = UserDefaults.standard
        let urlString = URLConstants.Feeds.Fetch
        guard let url = URL(string: urlString),
            let token = sud.object(forKey: Constants.UserDefaultsKeys.AuthToken) else {
            let error = NetworkControllerError.invalidURL(urlString)
            let payload = Either<NetworkControllerError, Feeds>.left(error)
            completionHandler(payload)

            return
        }

        var request = URLRequest(url: url)
        let bearer = "Bearer \(token)"
        request.addValue(bearer, forHTTPHeaderField: "Authorization")
        request.httpMethod = HTTPVerbs.GET

        session.fetch(request: request) { (result: Either<NetworkControllerError, Data>) in
            switch result {
            case .left(let error):
                let errorPayload = Either<NetworkControllerError, Feeds>.left(error)
                completionHandler(errorPayload)
            case .right(let data):
                do {
                    if let input = try JSONSerialization.jsonObject(with: data,
                                                                    options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String: Any]] { // swiftlint:disable:this line_length
                        let feeds = input.map({ (rawFeed: [String: Any]) -> Feed in
                            return Feed(rawInput: rawFeed)!
                        })
                        let payload = Either<NetworkControllerError, Feeds>.right(feeds)
                        completionHandler(payload)
                    }
                } catch {
                    let networkError = NetworkControllerError.forwarded(error)
                    let payload = Either<NetworkControllerError, Feeds>.left(networkError)
                    completionHandler(payload)
                }
            }
        }
    }

    func subscribeToFeed(feedURL: String, completionHandler: @escaping FeedsCompletionHandler) {
        let sud = UserDefaults.standard
        let urlString = URLConstants.Feeds.Subscribe
        guard let url = URL(string: urlString),
            let token = sud.object(forKey: Constants.UserDefaultsKeys.AuthToken) else {
            let error = NetworkControllerError.invalidURL(urlString)
            let payload = Either<NetworkControllerError, Feeds>.left(error)
            completionHandler(payload)

            return
        }

        var request = URLRequest(url: url)
        let bearer = "Bearer \(token)"
        request.addValue(bearer, forHTTPHeaderField: "Authorization")
        request.httpMethod = HTTPVerbs.POST
        let payload = [
            "url": feedURL
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        } catch {
            let error = NetworkControllerError.invalidPayload(url)
            let errorPayload = Either<NetworkControllerError, Feeds>.left(error)
            completionHandler(errorPayload)
            return
        }

        session.post(request: request) { (result: Either<NetworkControllerError, Data>) in
            switch result {
            case .left(let error):
                let errorPayload = Either<NetworkControllerError, Feeds>.left(error)
                completionHandler(errorPayload)
            case .right(let data):
                do {
                    let decoder = JSONDecoder()
                    let feed = try decoder.decode(Feed.self, from: data)
                    let payload = Either<NetworkControllerError, Feeds>.right([feed])
                    completionHandler(payload)
                } catch {
                    let networkError = NetworkControllerError.forwarded(error)
                    let payload = Either<NetworkControllerError, Feeds>.left(networkError)
                    completionHandler(payload)
                }
            }
        }
    }
}
