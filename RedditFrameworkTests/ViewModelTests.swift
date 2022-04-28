//
//  ViewModelTests.swift
//  RedditFrameworkTests
//
//  Created by Sukanya Yanamala on 4/12/22.
//

import XCTest
import Combine
@testable import RedditFramework

class ViewModelTests: XCTestCase {

    private var subscribers = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetStories_Success() throws {
        //Given
        let fakeNetworkManager = FakeNetworkManager()
        let data = try getDataFrom(jsonFile: "reddit_response_success")
        fakeNetworkManager.data = data
        let remote = RemoteRepository(networkManager: fakeNetworkManager)
        let repository = Repository(remote: remote, local: nil)
        let viewModel = ViewModel(repository: repository)
        let expectation = expectation(description: "waiting for publisher")
        var stories: [Story] = []
        
        //When
        viewModel.getStories()
        viewModel
            .$stories
            .sink { result in
                stories = result
                expectation.fulfill()
            }
            .store(in: &subscribers)
        
        //Then
        waitForExpectations(timeout: 2.0)
        XCTAssertEqual(stories.count, 25)
        XCTAssertTrue(stories.first?.title == "These are Ukrainian refugees after cleaning up a park in Poland as a thank you for hosting them. They're organising these things all over Poland now")
    }

    func testGetStories_Failure() throws {
        //Given
        let fakeNetworkManager = FakeNetworkManager()
        fakeNetworkManager.error = NetworkError.badURL
        let remote = RemoteRepository(networkManager: fakeNetworkManager)
        let repository = Repository(remote: remote, local: nil)
        let viewModel = ViewModel(repository: repository)
        let expectation = expectation(description: "waiting for publisher")
        var error: NetworkError?
        
        //When
        viewModel.getStories()
        viewModel
            .$error
            .sink { result in
                error = result
                expectation.fulfill()
            }
            .store(in: &subscribers)
        
        //Then
        waitForExpectations(timeout: 2.0)
        XCTAssertNotNil(error)
    }
    
    private func getDataFrom(jsonFile: String) throws -> Data {
        let bundle = Bundle(for: ViewModelTests.self)
        guard let url = bundle.url(forResource: jsonFile, withExtension: "json")
        else { return Data() }
        return try Data(contentsOf: url)
    }
    
}
