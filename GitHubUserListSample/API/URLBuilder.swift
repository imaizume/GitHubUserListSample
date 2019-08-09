//
//  URLBuilder.swift
//  GitHubUserListSample
//
//  Created by Tomohiro Imaizumi on 2019/08/10.
//  Copyright © 2019 imaizume. All rights reserved.
//

import Foundation

/**
 `api.github.com` へのリクエストURLを組み立てるヘルパー
 */
enum GitHubURLBuilder {

    /// ユーザー一覧: api.github.com/users
    case users

    /// ユーザー詳細
    /// login指定: api.github.com/users/{login}
    /// ID指定: api.github.com/user/{id}
    case user(_ byIdOrLogin: Either<Int, String>)

    case userRepos(_ login: String)

    private static let baseURL: String = "https://api.github.com"

    var fullPath: String {
        var components = URLComponents(string: GitHubURLBuilder.baseURL)!

        switch self {
        case .users:
            components.path.append("/users")

        case let .user(idOrLogin):
            switch idOrLogin {
            case let .left(id):
                components.path.append("/user")
                components.path.append("/\(id)")
            case let .right(login):
                components.path.append("/users")
                components.path.append("/\(login)")
            }

        case let .userRepos(login):
            components.path.append("/users")
            components.path.append("/\(login)")
            components.path.append("/repos")
        }
        return components.url!.absoluteString
    }
}
