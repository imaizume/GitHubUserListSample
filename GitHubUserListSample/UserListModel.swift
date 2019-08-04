//
//  UserListModel.swift
//  GitHubUserListSample
//
//  Created by Tomohiro Imaizumi on 2019/08/05.
//  Copyright © 2019 imaizume. All rights reserved.
//

import Foundation

protocol UserListModelInput: class {

    var users: [GitHubUser] { get }

    func setOutput(_ output: UserListModelOutput)

    func fetchUsers(sinse id: Int)
}

protocol UserListModelOutput: class {

    func didFetchUsers()
}

class UserListModel: NSObject {
    private(set) weak var output: UserListModelOutput? = nil

    private(set) var users: [GitHubUser] = [] {
        didSet {
            self.output?.didFetchUsers()
        }
    }

    func setOutput(_ output: UserListModelOutput) {
        self.output = output
    }
}

extension UserListModel: UserListModelInput {
    func fetchUsers(sinse id: Int) {
        GitHubUsers.fetch(since: id) { errorOrUsers in
            switch errorOrUsers {
            case let .left(error):
                print(error)
                // TODO: assert error
                break
            case let .right(users):
                self.users.append(contentsOf: users)
            }
        }
    }
}
