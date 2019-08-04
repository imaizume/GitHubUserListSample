//
//  UserListViewController.swift
//  GitHubUserListSample
//
//  Created by 今泉 智博 on 2019/07/30.
//  Copyright © 2019 imaizume. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController {

    @IBOutlet weak var usersTableView: UITableView!

    private lazy var presenter: UserListPresenterInput = UserListPresenter(self, UserListModel())

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.fetchUsers()
    }
}

extension UserListViewController: UserListPresenterOutput {
    var tableView: UITableView! {
        return self.usersTableView
    }
}

