//
//  CDStory+Utils.swift
//  RedditChallenge
//
//  Created by Sukanya Yanamala on 4/5/22.
//

import Foundation

extension CDStory {
    
    func createStory() -> Story {
        return Story(title: title, thumbnail: nil, score: Int(score), numComments: Int(numComments))
    }
    
}
