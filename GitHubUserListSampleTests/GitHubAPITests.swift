//
//  GitHubAPITests.swift
//  GitHubUserListSampleTests
//
//  Created by Tomohiro Imaizumi on 2019/08/04.
//  Copyright © 2019 imaizume. All rights reserved.
//

import XCTest
@testable import GitHubUserListSample

class GitHubAPITests: XCTestCase {
    func testZenFetch() {
        let expectation = self.expectation(description: "API")

        GitHubZen.fetch { errorOrZen in
            switch errorOrZen {
            case let .left(error):
                XCTFail("\(error)")
            case let .right(zen):
                XCTAssertNotNil(zen)
            }

            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 10)
    }

    func testZenFetchTwice() {
        let expectation = self.expectation(description: "API")

        GitHubZen.fetch { errorOrZen in
            switch errorOrZen {
            case let .left(error):
                XCTFail("\(error)")
            case .right(_):
                GitHubZen.fetch { errorOrZen in
                    switch errorOrZen {
                    case let .left(error):
                        XCTFail("\(error)")
                    case let .right(zen):
                        XCTAssertNotNil(zen)
                    }

                    expectation.fulfill()
                }
            }
        }

        self.waitForExpectations(timeout: 10)
    }

    func testUser() throws {
        let response: Response = (
            statusCode: .ok,
            headers: [:],
            payload: try JSONSerialization.data(withJSONObject: [
                "id" : 1,
                "login": "octocat",
                "avatar_url": "https://pbs.twimg.com/profile_images/1157035760085684224/iuxTnT5g_400x400.jpg"
            ])
        )

        switch GitHubUser.from(response: response) {
        case let .left(error):
            XCTFail("\(error)")
        case let .right(user):
            XCTAssertEqual(user.id, 1)
            XCTAssertEqual(user.login, "octocat")
        }
    }

    func testUserFetch() {
        let expectation = self.expectation(description: "API")

        GitHubUser.fetch(byLogin: "imaizume") { errorOrUser in
            switch errorOrUser {
            case let .left(error):
                XCTFail("\(error)")
            case let .right(user):
                XCTAssertEqual(user.id, 16273903)
                XCTAssertEqual(user.login, "imaizume")
            }

            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 10)
    }

    func testUsersFetch() {
        let expectation = self.expectation(description: "API")

        GitHubUsers.fetch(since: 16273902) { errorOrUsers in
            switch errorOrUsers {
            case let .left(error):
                XCTFail("\(error)")
            case let .right(users):
                let user1 = users[0]
                XCTAssertEqual(user1.id, 16273903)
                XCTAssertEqual(user1.login, "imaizume")
                XCTAssertNotNil(user1.avatarUrl)
                let user2 = users[1]
                XCTAssertEqual(user2.id, 16273904)
                XCTAssertEqual(user2.login, "rayqiri")
                XCTAssertNotNil(user2.avatarUrl)
                XCTAssertEqual(users.count, 30)
            }

            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 10)
    }
}
