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

    static func fetch(_ block: @escaping (Either<Either<ConnectionError, TransformError>, GitHubZen>) -> Void) {
        let urlString = "https://api.github.com/zen"
//        guard let url = URL(string: urlString) else {
//            block(.left(.left(.malformedURL(debugInfo: urlString))))
//            return
//        }

        let input: Input = (
            urlString,
            queries: [],
            headers: [:],
            methodAndPayload: .get
        )

        WebAPI.call(with: input) { output in
            switch output {
            case let .noResponse(connectionError):
                block(.left(.left(connectionError)))

            case let .hasResponse(response: response):
                let errorOrZen = GitHubZen.from(response: response)
                switch errorOrZen {
                case let .left(error):
                    block(.left(.right(error)))

                case let .right(zen):
                    block(.right(zen))
                }
            }
        }
    }

    enum TransformError {
        case unexpectedStatusCode(debugInfo: String)
        case malformedData(debugInfo: String)
    }
}

struct GitHubUser: Codable {
    let id: Int
    let login: String
    let avatarUrl: String

    static func from(response: Response) -> Either<TransformError, GitHubUser> {
        switch response.statusCode {
        case .ok:
            do {
                let jsonDecoder: JSONDecoder = .init()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let user = try jsonDecoder.decode(GitHubUser.self, from: response.payload)
                return .right(user)
            } catch {
                return .left(.malformedData(debugInfo: "\(error)"))
            }
        default:
            return .left(.unexpectedStatusCode(debugInfo: "\(response.statusCode)"))
        }
    }

    static func fetch(
        byLogin login: String,
        _ block: @escaping (Either<Either<ConnectionError, TransformError>, GitHubUser>) -> Void) {

        let urlString: String = "https://api.github.com/users/\(login)"
//        guard let url = URL(string: urlString)?.appendingPathComponent(login) else {
//            block(.left(.left(.malformedURL(debugInfo: "\(urlString)/\(login)"))))
//            return
//        }

        let input: Input = (
            urlString,
            queries: [],
            headers: [:],
            methodAndPayload: .get
        )

        WebAPI.call(with: input) { output in
            switch output {
            case let .noResponse(connectionError):
                block(.left(.left(connectionError)))
            case let .hasResponse(response):
                let errorOrUser = GitHubUser.from(response: response)
                switch errorOrUser {
                case let .left(transformError):
                    block(.left(.right(transformError)))
                case let .right(user):
                    block(.right(user))
                }
            }
        }
    }


    enum TransformError {
        case unexpectedStatusCode(debugInfo: String)
        case malformedData(debugInfo: String)
    }
}

struct GitHubUsers {

    let since: Int

    static func from(response: Response) -> Either<TransformError, [GitHubUser]> {
        switch response.statusCode {
        case .ok:
            do {
                let jsonDecoder: JSONDecoder = .init()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let users: [GitHubUser] = try jsonDecoder.decode([GitHubUser].self, from: response.payload)
                return .right(users)
            } catch {
                return .left(.malformedData(debugInfo: "\(error)"))
            }
        default:
            return .left(.unexpectedStatusCode(debugInfo: "\(response.statusCode)"))
        }
    }

    static func fetch(
        since: Int,
        _ block: @escaping (Either<Either<ConnectionError, TransformError>, [GitHubUser]>) -> Void) {

        let urlString: String = "https://api.github.com/users"

        let input: Input = (
            urlString,
            queries: [.init(name: "since", value: "\(since)")],
            headers: [:],
            methodAndPayload: .get
        )

        WebAPI.call(with: input) { output in
            switch output {
            case let .noResponse(connectionError):
                block(.left(.left(connectionError)))
            case let .hasResponse(response):
                let errorOrUsers = GitHubUsers.from(response: response)
                switch errorOrUsers {
                case let .left(transformError):
                    block(.left(.right(transformError)))
                case let .right(users):
                    block(.right(users))
                }
            }
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
