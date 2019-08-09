//
//  Output.swift
//  GitHubUserListSample
//
//  Created by Tomohiro Imaizumi on 2019/08/10.
//  Copyright © 2019 imaizume. All rights reserved.
//

import Foundation

enum Output {
    case noResponse(ConnectionError)
    case hasResponse(Response)
}

enum ConnectionError {
    case noDataOrNoResponse(debugInfo: String)
    case malformedURL(debugInfo: String)
}

typealias Response = (
    statusCode: HTTPStatus,
    headers: [String: String],
    payload: Data
)

enum HTTPStatus {
    case ok
    case notFound
    case unsupported(code: Int)

    static func from(code: Int) -> HTTPStatus {
        switch code {
        case 200:
            return .ok
        case 404:
            return notFound
        default:
            return .unsupported(code: code)
        }
    }
}
