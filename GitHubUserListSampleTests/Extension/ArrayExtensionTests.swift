//
//  ArrayExtensionTests.swift
//  GitHubUserListSampleTests
//
//  Created by Tomohiro Imaizumi on 2019/08/11.
//  Copyright © 2019 imaizume. All rights reserved.
//

import XCTest
@testable import GitHubUserListSample

class ArrayExtensionTests: XCTest {
    func testSafeSubscript() {
        let array: [Int] = [1, 2, 3]
        XCTContext.runActivity(named: "throws no error") { _ in
            XCTAssertNoThrow(print(array[safe: -1]!))
            XCTAssertNoThrow(print(array[safe: 4]!))
        }

        XCTContext.runActivity(named: "returns nil when out of range") { _ in
            XCTAssertNil(array[safe: -1])
            XCTAssertNil(array[safe: 4])
        }

        XCTContext.runActivity(named: "returns value among range") { _ in
            XCTAssertEqual(array[safe: 1], 1)
            XCTAssertEqual(array[safe: 3], 3)
        }

    }
}
