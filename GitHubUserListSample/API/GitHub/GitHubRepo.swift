//
//  GitHubRepo.swift
//  GitHubUserListSample
//
//  Created by Tomohiro Imaizumi on 2019/08/11.
//  Copyright © 2019 imaizume. All rights reserved.
//

import Foundation

struct GitHubRepo: Codable {
    let name: String
    let language: String?
    let stargazersCount: Int
    let description: String?
    let htmlUrl: String

    static func from(response: Response) -> Either<TransformError, [GitHubRepo]> {
        switch response.statusCode {
        case .ok:
            do {
                let jsonDecoder: JSONDecoder = .init()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let user: [GitHubRepo] = try jsonDecoder.decode([GitHubRepo].self, from: response.payload)
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
        _ block: @escaping (Either<Either<ConnectionError, TransformError>, [GitHubRepo]>) -> Void) {

        let input: Input = (
            GitHubURLBuilder.userRepos(login).fullPath,
            queries: [],
            headers: Const.GitHub.authorizationHeader,
            methodAndPayload: .get
        )

        WebAPI.call(with: input) { output in
            switch output {
            case let .noResponse(connectionError):
                block(.left(.left(connectionError)))
            case let .hasResponse(response):
                let errorOrUsers = GitHubRepo.from(response: response)
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
