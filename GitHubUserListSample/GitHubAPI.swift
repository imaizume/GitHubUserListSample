//
//  GitHubAPI.swift
//  GitHubUserListSample
//
//  Created by 今泉 智博 on 2019/07/31.
//  Copyright © 2019 imaizume. All rights reserved.
//

import Foundation

struct GitHubZen {
    /// Zen Phrase
    let text: String

    static func from(response: Response) -> Either<TransformError, GitHubZen> {
        switch response.statusCode {
        case .ok:
            guard let string = String(data: response.payload, encoding: .utf8) else {
                return Either.left(TransformError.malformedData(debugInfo: "not UTF-8 string"))
            }

            return .right(GitHubZen(text: string))
        case .notFound, .unsupported:
            return .left(.unexpectedStatusCode(debugInfo: "\(response.statusCode)"))
        }

    }

    enum TransformError {
        case unexpectedStatusCode(debugInfo: String)
        case malformedData(debugInfo: String)
    }
}

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


enum GitHubZenResponse {
    case success(GitHubZen)
    case faliure(GitHubZen.TransformError)
}
