//
//  GitHubUser.swift
//  GitHubUserListSample
//
//  Created by Tomohiro Imaizumi on 2019/08/11.
//  Copyright © 2019 imaizume. All rights reserved.
//

import Foundation

protocol GitHubUserContract {
    static func fetch(
        byLogin login: String,
        _ block: @escaping (Either<Either<ConnectionError, TransformError>, GitHubUser>) -> Void)

    static func fetch(
        byId id: Int,
        _ block: @escaping (Either<Either<ConnectionError, TransformError>, GitHubUser>) -> Void)

    static func fetch(
        sinceId id: Int,
        _ block: @escaping (Either<Either<ConnectionError, TransformError>, [GitHubUser]>) -> Void)
}

struct GitHubUser: Codable, GitHubUserContract {
    let id: Int
    let avatarUrl: String
    let login: String
    let name: String?
    let followers: Int = 0
    let following: Int = 0

    static func from<U: Decodable>(response: Response) -> Either<TransformError, U> {
        switch response.statusCode {
        case .ok:
            do {
                let jsonDecoder: JSONDecoder = .init()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let user: U = try jsonDecoder.decode(U.self, from: response.payload)
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

        let input: Input = (
            GitHubURLBuilder.user(.right(login)).fullPath,
            queries: [],
            headers: Const.GitHub.authorizationHeader,
            methodAndPayload: .get
        )

        WebAPI.call(with: input) { output in
            switch output {
            case let .noResponse(connectionError):
                block(.left(.left(connectionError)))
            case let .hasResponse(response):
                let errorOrUser: Either<TransformError, GitHubUser> = GitHubUser.from(response: response)
                switch errorOrUser {
                case let .left(transformError):
                    block(.left(.right(transformError)))
                case let .right(user):
                    block(.right(user))
                }
            }
        }
    }

    static func fetch(
        byId id: Int,
        _ block: @escaping (Either<Either<ConnectionError, TransformError>, GitHubUser>) -> Void) {

        let input: Input = (
            GitHubURLBuilder.user(.left(id)).fullPath,
            queries: [],
            headers: Const.GitHub.authorizationHeader,
            methodAndPayload: .get
        )

        WebAPI.call(with: input) { output in
            switch output {
            case let .noResponse(connectionError):
                block(.left(.left(connectionError)))
            case let .hasResponse(response):
                let errorOrUsers: Either<TransformError, GitHubUser> = GitHubUser.from(response: response)
                switch errorOrUsers {
                case let .left(transformError):
                    block(.left(.right(transformError)))
                case let .right(users):
                    block(.right(users))
                }
            }
        }
    }

    static func fetch(
        sinceId id: Int,
        _ block: @escaping (Either<Either<ConnectionError, TransformError>, [GitHubUser]>) -> Void) {

        let input: Input = (
            GitHubURLBuilder.users.fullPath,
            queries: [.init(name: "since", value: "\(id)")],
            headers: Const.GitHub.authorizationHeader,
            methodAndPayload: .get
        )

        WebAPI.call(with: input) { output in
            switch output {
            case let .noResponse(connectionError):
                block(.left(.left(connectionError)))
            case let .hasResponse(response):
                let errorOrUsers: Either<TransformError, [GitHubUser]> = GitHubUser.from(response: response)
                switch errorOrUsers {
                case let .left(transformError):
                    block(.left(.right(transformError)))
                case let .right(users):
                    block(.right(users))
                }
            }
        }
    }
}

struct GitHubUserStub: GitHubUserContract {
    static func fetch(byId id: Int, _ block: @escaping (Either<Either<ConnectionError, TransformError>, GitHubUser>) -> Void) {
        let user: GitHubUser = .init(
            id: 0,
            avatarUrl: "https://user-images.githubusercontent.com/16273903/61364087-16219e80-a8c0-11e9-84be-75b6cf9db057.png",
            login: "octocat",
            name: "GitHub Character")
        block(.right(user))
    }

    static func fetch(sinceId id: Int, _ block: @escaping (Either<Either<ConnectionError, TransformError>, [GitHubUser]>) -> Void) {
        let ids: [Int] = Array(0..<30).map { i in i + id + 1 }
        let users: [GitHubUser] = ids.map { id in
            return .init(
                id: id,
                avatarUrl: "https://user-images.githubusercontent.com/16273903/61364087-16219e80-a8c0-11e9-84be-75b6cf9db057.png",
                login: "octocat \(id)",
                name: "GitHub Character \(id)")
        }
        block(.right(users))
    }

    static func fetch(
        byLogin login: String,
        _ block: @escaping (Either<Either<ConnectionError, TransformError>, GitHubUser>) -> Void) {

        let user: GitHubUser = .init(
            id: 0,
            avatarUrl: "https://user-images.githubusercontent.com/16273903/61364087-16219e80-a8c0-11e9-84be-75b6cf9db057.png",
            login: "octocat",
            name: "GitHub Character")
        block(.right(user))
    }
}
