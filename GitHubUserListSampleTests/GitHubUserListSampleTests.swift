//
//  GitHubUserListSampleTests.swift
//  GitHubUserListSampleTests
//
//  Created by 今泉 智博 on 2019/07/30.
//  Copyright © 2019 imaizume. All rights reserved.
//

import XCTest
@testable import GitHubUserListSample

class GitHubUserListSampleTests: XCTestCase {
    func testRequest() {
        let input: Request = (
            urlString: "https://api.github.com/zen",
            queries: [],
            headers: [:],
            methodAndPayload: .get
        )
        WebAPI.call(with: input)
    }

    func testResponse() {
        let payloadString: String = "this is a response text"
        let response: Response = (
            statusCode: .ok,
            headers: [:],
            payload: payloadString.data(using: .utf8)!
        )

        let errorOrZen = GitHubZen.from(response: response)
        switch errorOrZen {
        case .left(let error):
            XCTFail("\(error)")
        case .right(let zen):
            XCTAssertEqual(zen.text, payloadString)
        }
    }

    func testRequestAndResponse() {
        let expectation = self.expectation(description: "wait for API response")

        let input: Input = (
            urlString: "https://api.github.com/zen",
            queries: [],
            headers: [:],
            methodAndPayload: .get
        )


        WebAPI.call(with: input) { output in
            switch output {
            case let .noResponse(connectionError):
                XCTFail("\(connectionError)")
            case let .hasResponse(response):
                let errorOrZen = GitHubZen.from(response: response)
                XCTAssertNotNil(errorOrZen.right)
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 10)
    }
}
