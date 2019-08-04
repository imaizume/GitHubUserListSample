//
//  WebAPI.swift
//  GitHubUserListSample
//
//  Created by 今泉 智博 on 2019/07/30.
//  Copyright © 2019 imaizume. All rights reserved.
//

import Foundation

typealias Input = Request

typealias Request = (
    url: URL,
    queries: [URLQueryItem],
    headers: [String: String],
    methodAndPayload: HTTPMethodAndPayload
)

enum HTTPMethodAndPayload {
    case get
    case post

    var method: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }

    var body: Data? {
        switch self {
        case .get:
            return nil
        case .post:
            return nil
        }
    }
}

enum WebAPI {
    static func call(with input: Input, _ block: @escaping (Output) -> Void) {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            let response: Response = (
                statusCode: .ok,
                headers: [:],
                payload: "this is a response text".data(using: .utf8)!
            )

            block(.hasResponse(response))
        }
    }

    static func call(with input: Input) {
        self.call(with: input) { _ in
            // nothing to do in this callback
        }
    }
}

enum Output {
    case hasResponse(Response)
    case noResponse(ConnectionError)
}

enum ConnectionError {
    case noDataOrNoResponse(debugInfo: String)
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
