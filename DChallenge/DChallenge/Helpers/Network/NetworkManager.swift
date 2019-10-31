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
