//
//  GitHubAPI.swift
//  GitHubUserListSample
//
//  Created by 今泉 智博 on 2019/07/31.
//  Copyright © 2019 imaizume. All rights reserved.
//

import Foundation

enum Either<Left, Right> {
    case left(Left)
    case right(Right)

    var left: Left? {
        switch self {
        case let .left(x):
            return x
        case .right:
            return nil
        }
    }

    var right: Right? {
        switch self {
        case .left:
            return nil
        case let .right(x):
            return x
        }
    }
}

enum TransformError {
    case unexpectedStatusCode(debugInfo: String)
    case malformedData(debugInfo: String)
}
