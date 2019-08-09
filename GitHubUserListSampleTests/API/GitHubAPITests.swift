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

    func testGitHubUserResponse() throws {
        let response: Response = (
            statusCode: .ok,
            headers: [:],
            payload: try JSONSerialization.data(withJSONObject: [
                "id": 1,
                "login": "octocat",
                "avatar_url": "https://example.com/image.jpg"
                ])
        )
        let result: Either<TransformError, GitHubUser> = GitHubUser.from(response: response)
        switch result {
        case let .left(error):
            XCTFail("\(error)")
        case let .right(user):
            XCTAssertEqual(user.id, 1)
            XCTAssertEqual(user.login, "octocat")
            XCTAssertEqual(user.avatarUrl, "https://example.com/image.jpg")
        }
    }

    func testGitHubUserFetch() {
        let expectationForLogin = self.expectation(description: "byLogin")
        let expectationForId = self.expectation(description: "byId")
        var userByLogin: GitHubUser?, userById: GitHubUser?

        GitHubUser.fetch(byLogin: "imaizume") { errorOrUser in
            switch errorOrUser {
            case let .left(error):
                XCTFail("\(error)")
            case let .right(user):
                XCTAssertEqual(user.id, 16273903)
                XCTAssertEqual(user.login, "imaizume")
                XCTAssertFalse(user.avatarUrl.isEmpty)
                userByLogin = user
            }

            expectationForLogin.fulfill()
        }

        GitHubUser.fetch(byId: 16273903) { errorOrUser in
            switch errorOrUser {
            case let .left(error):
                XCTFail("\(error)")
            case let .right(user):
                XCTAssertNotNil(user)
                userById = user
            }

            expectationForId.fulfill()
        }

        self.waitForExpectations(timeout: 10) { _ in
            XCTAssertEqual(userById?.id, userByLogin?.id)
            XCTAssertEqual(userById?.name, userByLogin?.name)
            XCTAssertEqual(userById?.login, userByLogin?.login)
            XCTAssertEqual(userById?.avatarUrl, userByLogin?.avatarUrl)
            XCTAssertEqual(userById?.followers, userByLogin?.followers)
            XCTAssertEqual(userById?.following, userByLogin?.following)
        }
    }

    func testGitHubUsersFetch() {
        let expectation = self.expectation(description: "API")

        GitHubUser.fetch(sinceId: 16273902) { errorOrUsers in
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

    func testGitHubReposFetch() {
        let expectation = self.expectation(description: "API")

        GitHubRepo.fetch(byLogin: "imaizume") { errorOrRepos in
            switch errorOrRepos {
            case let .left(error):
                XCTFail("\(error)")
            case let .right(repos):
                XCTAssertFalse(repos.isEmpty)
                let repo = repos[0]
                XCTAssertFalse(repo.name.isEmpty)
                XCTAssertFalse(repo.htmlUrl.isEmpty)
            }

            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 10)
    }
}
