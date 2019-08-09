//
//  UserListModel.swift
//  GitHubUserListSample
//
//  Created by Tomohiro Imaizumi on 2019/08/05.
//  Copyright © 2019 imaizume. All rights reserved.
//

import Foundation

/**
 UserListModelの出力先に要求するインターフェイス
 */
protocol UserListModelOutput: class {
    /// ユーザー一覧の取得完了時に呼ばれる
    func didFetchUsers()
}

/**
 ユーザー一覧を表現するモデル
 */
class UserListModel: NSObject {

    // MARK: - Properties

    // MARK: internal

    private(set) weak var output: UserListModelOutput?

    /// 取得したユーザー
    private(set) var users: [GitHubUser] = [] {
        didSet {
            if let lastId: Int = self.users.map({ $0.id }).max() {
                self.startUserId = lastId
            }
            self.output?.didFetchUsers()
        }
    }

    // MARK: private

    /// ユーザー一覧取得時に指定する `since` パラメータに付与する値
    /// 初回のリクエストでは[github.com/imaizume](https://github.com/imaizume)のユーザーID - 1を指定
    /// 2回目以降は取得したユーザーの最大のIDを指定
    ///
    /// [Users - Get all users \| GitHub Developer Guide](https://developer.github.com/v3/users/#get-all-users)
    private var startUserId: Int = Const.GitHub.startUserId - 1

    /// APIコール中であれば `true` になる
    private var isLoading: Bool = false

    private let gitHubUser: GitHubUserContract.Type

    // MARK: - Methods

    // MARK: lifecycle

    required init(_ output: UserListModelOutput, withGitHubUser gitHubUser: GitHubUserContract.Type) {
        self.output = output
        self.gitHubUser = gitHubUser
    }

    // MARK: internal

    /// ユーザー一覧を取得する
    func fetchUsers() {
        guard !self.isLoading else { return }
        self.startLoading()
        self.gitHubUser.fetch(sinceId: self.startUserId) { errorOrUsers in
            self.finishLoading()
            switch errorOrUsers {
            case let .left(error):
                print(error)
                // TODO: assert error

            case let .right(users):
                self.users.append(contentsOf: users.sorted(by: { (user1, user2) in user1.id < user2.id }))
            }
        }
    }

    // MARK: private

    /// APIコール状態をONにする
    private func startLoading() { self.isLoading = true }

    /// APIコール状態をOFFにする
    private func finishLoading() { self.isLoading = false }
}
