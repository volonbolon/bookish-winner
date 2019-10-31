//
//  URLSession+NetworkInterface.swift
//  DChallenge
//
//  Created by Ariel Rodriguez on 31/10/2019.
//  Copyright © 2019 Ariel Rodriguez. All rights reserved.
//

import Foundation

extension URLSession: NetworkSession {
    func delete(request: URLRequest, completionHandler: @escaping (NetworkControllerError?) -> Void) {
        let task = dataTask(with: request) { (_: Data?, res: URLResponse?, error: Error?) in
            guard error == nil else {
                let networkError = NetworkControllerError.forwarded(error!)
                completionHandler(networkError)

                return
            }
            completionHandler(nil)
        }
        task.resume()
    }

    func fetch(request: URLRequest, completionHandler: @escaping NetworkSession.NetworkSessionCompletionHandler) {
        let task = self.dataTask(with: request) { (data: Data?, _: URLResponse?, error: Error?) in
            guard error == nil else {
                let networkError = NetworkControllerError.forwarded(error!)
                let payload = Either<NetworkControllerError, Data>.left(networkError)
                completionHandler(payload)

                return
            }

            guard let jsonData = data else {
                let payloadError = NetworkControllerError.invalidPayload(request.url!)
                let payload = Either<NetworkControllerError, Data>.left(payloadError)
                completionHandler(payload)

                return
            }

            let payload = Either<NetworkControllerError, Data>.right(jsonData)
            completionHandler(payload)
        }
        task.resume()
    }

    func post(request: URLRequest,
              completionHandler: @escaping NetworkSession.NetworkSessionCompletionHandler) {
        let task = dataTask(with: request) { (data: Data?, _: URLResponse?, error: Error?) in
            guard error == nil else {
                let networkError = NetworkControllerError.forwarded(error!)
                let payload = Either<NetworkControllerError, Data>.left(networkError)
                completionHandler(payload)

                return
            }

            guard let jsonData = data else {
                let payloadError = NetworkControllerError.invalidPayload(request.url!)
                let payload = Either<NetworkControllerError, Data>.left(payloadError)
                completionHandler(payload)

                return
            }

            let payload = Either<NetworkControllerError, Data>.right(jsonData)
            completionHandler(payload)
        }
        task.resume()
    }
}
