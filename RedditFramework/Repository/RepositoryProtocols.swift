//
//  RepositoryProtocols.swift
//  RedditChallenge
//
//  Created by Sukanya Yanamala on 4/5/22.
//

import Foundation

public protocol RepositoryProtocol: RemoteRepositoryProtocol, LocalRepositoryProtocol {
    var remote: RemoteRepositoryProtocol { get }
    var local: LocalRepositoryProtocol? { get }
}

//
public typealias SuccessResponse = ([Story], String)
public protocol RemoteRepositoryProtocol {
    func getStories(from url: String, _ completionHandler: @escaping (Result<SuccessResponse, NetworkError>) -> Void)
    func getData(from url: String, completionHandler: @escaping (Result<Data, NetworkError>) -> Void)
}

// will be in charge to save data on disk
public protocol LocalRepositoryProtocol {
    func getStories() -> [Story]
    func saveStories(_ stories: [Story])
    func removeAllStories()
}
