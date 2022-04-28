//
//  Remote.swift
//  RedditChallenge
//
//  Created by Sukanya Yanamala on 4/5/22.
//

import Foundation
import Combine

public class RemoteRepository: RemoteRepositoryProtocol {
    
    private let networkManager: NetworkManager
    private var subscribers = Set<AnyCancellable>()
    
    public init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    public func getStories(from url: String, _ completionHandler: @escaping (Result<SuccessResponse, NetworkError>) -> Void) {
        networkManager
            .getModel(RedditResponse.self, from: url)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            } receiveValue: { response in
                let afterKey = response.data.after
                let stories = response.data.children.map { $0.data }
                completionHandler(.success((stories, afterKey)))
            }
            .store(in: &subscribers)
    }
    
    public func getData(from url: String, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        networkManager.getData(from: url) { data in
            if let data = data {
                completionHandler(.success(data))
            } else {
                completionHandler(.failure(.badURL))
            }
        }
    }
}
