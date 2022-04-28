//
//  NetworkError.swift
//  RedditChallenge
//
//  Created by Sukanya Yanamala on 3/31/22.
//

import Foundation

public enum NetworkError: Error {
    case badURL
    case other(Error)
}
