//
//  Const.swift
//  GitHubUserListSample
//
//  Created by Tomohiro Imaizumi on 2019/08/10.
//  Copyright © 2019 imaizume. All rights reserved.
//

enum Const {
    enum GitHub {
        /// github.com/imaizume のユーザーID
        ///
        /// [api.github.com/users?since=16273902](https://api.github.com/users?since=16273902)
        static let startUserId: Int = 16273903

        static let personalAccessToken: String = "a08aac0c0e2eb8eaaf9e0e0ce6af9d24b2d24df0"

        static let authorizationHeader: [String: String] = ["Authorization": "token \(Const.GitHub.personalAccessToken)"]
    }
}
