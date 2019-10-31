//
//  Feed.swift
//  DChallenge
//
//  Created by Ariel Rodriguez on 31/10/2019.
//  Copyright © 2019 Ariel Rodriguez. All rights reserved.
//

import Foundation

struct Feed: Codable {
    var feedId: Int?
    var title: String
    var url: URL

    init?(rawInput: [String: Any]) {
        guard let id = rawInput["id"] as? Int,
    let title = rawInput["title"] as? String,
    let urlString = rawInput["url"] as? String, let url = URL(string: urlString) else {
            return nil
        }
        self.feedId = id
        self.title = title
        self.url = url
    }

    enum CodingKeys: String, CodingKey {
        case feedId = "id"
        case title
        case url
    }
}
