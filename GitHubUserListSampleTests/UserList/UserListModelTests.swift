//
//  UserListModelTests.swift
//  GitHubUserListSampleTests
//
//  Created by Tomohiro Imaizumi on 2019/08/11.
//  Copyright © 2019 imaizume. All rights reserved.
//

import XCTest
@testable import GitHubUserListSample

class UserListModelTests: XCTestCase {

    private var model: UserListModel!

    private var callCount: Int = 0

    private var expectation: XCTestExpectation?

    override func setUp() {
        super.setUp()
        self.model = .init(self, withGitHubUser: GitHubUserStub.self)
        self.callCount = 0
    }

    func testFetchUsersThreeTimes() {

        self.expectation = self.expectation(description: "API Call")
        self.model.fetchUsers()

        self.waitForExpectations(timeout: 10) { _ in
            let users: [GitHubUser] = self.model.users
            XCTAssertEqual(users.count, 90)
            XCTAssertEqual(users.last!.id, users.first!.id + 90 - 1)
        }
    }
}

extension UserListModelTests: UserListModelOutput {
    func didFetchUsers() {
        switch self.callCount {
        case 0..<2:
            self.callCount += 1
            self.model.fetchUsers()
        case 2:
            self.expectation?.fulfill()
        default: return
        }
    }
}
