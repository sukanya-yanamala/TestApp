//
//  RedditChallengeMockUITests.swift
//  RedditChallengeMockUITests
//
//  Created by Sukanya Yanamala on 4/12/22.
//

import XCTest

class RedditChallengeMockUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // validating table view
        let tablesQuery = app.tables
        let tableView = tablesQuery["table_view_stories"]
        XCTAssertTrue(tableView.exists)
        
        // validate first element
        let firstelement = tableView.staticTexts["Poland as a thank you for hosting them. They're organising these things all over Poland now"]
        XCTAssertTrue(firstelement.exists)
                                

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
