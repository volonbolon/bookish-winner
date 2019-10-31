//
//  NetworkSession.swift
//  DChallenge
//
//  Created by Ariel Rodriguez on 31/10/2019.
//  Copyright © 2019 Ariel Rodriguez. All rights reserved.
//

import Foundation

// Errors used by Network Session and Manager
enum NetworkControllerError: Error {
    case invalidURL(String)
    case invalidPayload(URL?)
    case forwarded(Error)
}

/*
 By encapsulating the session with a protocol, we can easily inject
 our own session into the manger, instead of using the shared singleton.
 This is helpful for tests (and also, for instance, to load items from different sources)
 */
protocol NetworkSession {
    typealias NetworkSessionCompletionHandler = (Either<NetworkControllerError, Data>) -> Void

    func fetch(request: URLRequest,
               completionHandler: @escaping NetworkSession.NetworkSessionCompletionHandler)
    func post(request: URLRequest,
              completionHandler:@escaping NetworkSessionCompletionHandler)
}
