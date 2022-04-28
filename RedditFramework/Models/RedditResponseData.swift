//
//  RedditResponseData.swift
//  RedditChallenge
//
//  Created by Sukanya Yanamala on 3/31/22.
//

import Foundation

public struct RedditResponseData: Codable {
    public let after: String
    public let children: [RedditChild]
}
