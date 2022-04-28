//
//  Story.swift
//  RedditChallenge
//
//  Created by Sukanya Yanamala on 3/31/22.
//

import Foundation

public struct Story: Codable {
    
    public let title: String?
    public let thumbnail: String?
    public let score: Int?
    public let numComments: Int?
    
    public enum CodingKeys: String, CodingKey {
        case title
        case thumbnail
        case score
        case numComments = "num_comments"
    }
}
