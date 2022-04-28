//
//  ViewControllerConfigurator.swift
//  RedditChallenge
//
//  Created by Sukanya Yanamala on 4/5/22.
//

import Foundation
import RedditFramework

class ViewControllerConfigurator {
    
    static func assemblingMVVM(view: ViewControllerProtocol) {
        let networkManager = MainNetworkManager()
        let remote = RemoteRepository(networkManager: networkManager)
        let repository = Repository(remote: remote, local: nil)
        let viewModel = ViewModel(repository: repository)
        view.viewModel = viewModel
    }
    
}
