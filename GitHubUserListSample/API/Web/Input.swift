//
//  Input.swift
//  GitHubUserListSample
//
//  Created by Tomohiro Imaizumi on 2019/08/10.
//  Copyright © 2019 imaizume. All rights reserved.
//

import Foundation

typealias Input = Request

typealias Request = (
    urlString: String,
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
