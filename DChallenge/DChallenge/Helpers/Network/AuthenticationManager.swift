//
//  AuthenticationManager.swift
//  DChallenge
//
//  Created by Ariel Rodriguez on 31/10/2019.
//  Copyright © 2019 Ariel Rodriguez. All rights reserved.
//

import Foundation

struct AuthenticationNetworkManager {
    typealias AuthToken = String
    typealias AuthenticationCompletionHandler = (Either<NetworkControllerError, AuthToken>) -> Void

    private let session: NetworkSession // here we can insert our own custom session

    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }

    func authenticate(username: String,
                      pswd: String,
                      isRegistering: Bool = false,
                      completionHandler: @escaping AuthenticationCompletionHandler) {
        let urlString = isRegistering ? URLConstants.Authentication.Register : URLConstants.Authentication.Login
        guard let url = URL(string: urlString) else {
            let error = NetworkControllerError.invalidURL(urlString)
            let payload = Either<NetworkControllerError, AuthToken>.left(error)
            completionHandler(payload)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = HTTPVerbs.POST
        let payload = [
            "user": username,
            "password": pswd
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        } catch {
            let error = NetworkControllerError.invalidPayload(url)
            let errorPayload = Either<NetworkControllerError, AuthToken>.left(error)
            completionHandler(errorPayload)
            return
        }
        session.post(request: request) { (result: Either<NetworkControllerError, Data>) in
            switch result {
            case .left(let error):
                let payload = Either<NetworkControllerError, AuthToken>.left(error)
                completionHandler(payload)
            case .right(let data):
                do {
                    if let input = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] { // swiftlint:disable:this line_length
                        if let token = input["access_token"] as? AuthToken {
                            let payload = Either<NetworkControllerError, AuthToken>.right(token)
                            completionHandler(payload)
                        } else {
                            let networkError = NetworkControllerError.invalidPayload(url)
                            let payload = Either<NetworkControllerError, AuthToken>.left(networkError)
                            completionHandler(payload)
                        }
                    }
                } catch {
                    let networkError = NetworkControllerError.forwarded(error)
                    let payload = Either<NetworkControllerError, AuthToken>.left(networkError)
                    completionHandler(payload)
                }
            }
        }
    }
}
