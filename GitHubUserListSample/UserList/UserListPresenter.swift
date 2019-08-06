//
//  UserListPresenter.swift
//  GitHubUserListSample
//
//  Created by Tomohiro Imaizumi on 2019/08/05.
//  Copyright © 2019 imaizume. All rights reserved.
//

import UIKit
import Kingfisher

protocol UserListPresenterInput {
    func fetchUsers()
}

protocol UserListPresenterOutput: class {
    var tableView: UITableView! { get }

    func open(byId id: Int, andLogin login: String)
}

class UserListPresenter: NSObject {
    weak var output: UserListPresenterOutput?
    private let input: UserListModelInput

    required init(
        _ output: UserListPresenterOutput?,
        _ input: UserListModelInput) {
        self.output = output
        self.input = input
        super.init()
        self.output?.tableView.register(UINib(nibName: UserListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: UserListTableViewCell.identifier)
        self.output?.tableView.delegate = self
        self.output?.tableView.dataSource = self
        self.input.setOutput(self)
        self.input.fetchUsers(sinse: 16273902)
    }
}

extension UserListPresenter: UserListPresenterInput {
    func fetchUsers() {
        self.output?.tableView.reloadData()
    }
}

extension UserListPresenter: UserListModelOutput {
    func didFetchUsers() {
        DispatchQueue.main.async {
            self.output?.tableView.reloadData()
        }
    }
}

extension UserListPresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UserListTableViewCell else {
            // TODO: assertion
            return
        }
        self.output?.open(byId: cell.user.id, andLogin: cell.user.login)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension UserListPresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserListTableViewCell.identifier, for: indexPath) as! UserListTableViewCell
        cell.initialize(by: self.input.users[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.input.users.count
    }
}
