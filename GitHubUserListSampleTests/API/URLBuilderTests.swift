//
//  URLBuilderTests.swift
//  GitHubUserListSampleTests
//
//  Created by Tomohiro Imaizumi on 2019/08/11.
//  Copyright © 2019 imaizume. All rights reserved.
//

import XCTest
@testable import GitHubUserListSample

class URLBuilderTests: XCTestCase {
    func testBuildGitHubURL() {
        XCTAssertEqual(GitHubURLBuilder.user(.left(0)).fullPath, "https://api.github.com/user/0")
        XCTAssertEqual(GitHubURLBuilder.user(.right("imaizume")).fullPath, "https://api.github.com/users/imaizume")
        XCTAssertEqual(GitHubURLBuilder.users.fullPath, "https://api.github.com/users")
        XCTAssertEqual(GitHubURLBuilder.userRepos("imaizume").fullPath, "https://api.github.com/users/imaizume/repos")
    }
}
