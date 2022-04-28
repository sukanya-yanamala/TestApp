//
//  Repository.swift
//  RedditChallenge
//
//  Created by Sukanya Yanamala on 4/5/22.
//

import Foundation

public class Repository: RepositoryProtocol {
    
    public let remote: RemoteRepositoryProtocol
    public let local: LocalRepositoryProtocol?
    
    public init(remote: RemoteRepositoryProtocol, local: LocalRepositoryProtocol?) {
        self.remote = remote
        self.local = local
    }
    
    public func getStories(from url: String, _ completionHandler: @escaping (Result<SuccessResponse, NetworkError>) -> Void) {
        remote.getStories(from: url, completionHandler)
    }
    
    public func getData(from url: String, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        remote.getData(from: url, completionHandler: completionHandler)
    }
    
    public func getStories() -> [Story] {
        local?.getStories() ?? []
    }
    
    public func saveStories(_ stories: [Story]) {
        local?.saveStories(stories)
    }
    
    public func removeAllStories() {
        local?.removeAllStories()
    }
    
}
