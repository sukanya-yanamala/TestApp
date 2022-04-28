//
//  FakeNetworkManager.swift
//  RedditChallengeMock
//
//  Created by Sukanya Yanamala on 4/12/22.
//

import Foundation
import Combine
import RedditFramework

class FakeNetworkManager: NetworkManager {
    
    var data: Data?
    var error: NetworkError?
    
    func getModel<Model>(_ model: Model.Type, from url: String) -> AnyPublisher<Model, NetworkError> where Model : Decodable {
        
        if let data = data {
            do {
                let result = try JSONDecoder().decode(model, from: data)
                return CurrentValueSubject<Model, NetworkError>(result).eraseToAnyPublisher()
            } catch { }
        }
        
        if let error = error {
            return Fail<Model, NetworkError>(error: error).eraseToAnyPublisher()
        }
        
        return Fail<Model, NetworkError>(error: .badURL).eraseToAnyPublisher()
    }
    
    func getData(from url: String, completionHandler: @escaping (Data?) -> Void) {
        if let data = data {
            completionHandler(data)
        }
    }
    
}

