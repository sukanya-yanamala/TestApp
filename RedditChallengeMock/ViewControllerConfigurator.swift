//
//  ViewControllerConfigurator.swift
//  RedditChallengeMock
//
//  Created by Sukanya Yanamala on 4/12/22.
//

import Foundation
import RedditFramework

class ViewControllerConfigurator {
    
    static func assemblingMVVM(view: ViewControllerProtocol) {
        let fakeNetworkManager = FakeNetworkManager()
        fakeNetworkManager.data = getDataFrom(jsonFile: "reddit_response_success")
        let remote = RemoteRepository(networkManager: fakeNetworkManager)
        let repository = Repository(remote: remote, local: nil)
        let viewModel = ViewModel(repository: repository)
        view.viewModel = viewModel
    }
    
    static private func getDataFrom(jsonFile: String) -> Data {
        let bundle = Bundle(for: ViewControllerConfigurator.self)
        guard let url = bundle.url(forResource: jsonFile, withExtension: "json")
        else { return Data() }
        
        do {
            return try Data(contentsOf: url)
        } catch {
            return Data()
        }
    }
}
