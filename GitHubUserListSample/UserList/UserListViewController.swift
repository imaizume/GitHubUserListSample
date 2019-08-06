//
//  UserListViewController.swift
//  GitHubUserListSample
//
//  Created by 今泉 智博 on 2019/07/30.
//  Copyright © 2019 imaizume. All rights reserved.
//

import Instantiate
import InstantiateStandard
import UIKit

class UserListViewController: UIViewController {

    @IBOutlet weak var usersTableView: UITableView!

    private lazy var presenter: UserListPresenterInput = UserListPresenter(self, UserListModel())

    override func loadView() {
        super.loadView()
        self.title = "Repository List"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.fetchUsers()
    }
}

extension UserListViewController: StoryboardInstantiatable {
    struct Dependency {
    }

    func inject(_ dependency: Dependency) {
    }
}

extension UserListViewController: UserListPresenterOutput {
    func open(byId id: Int, andLogin login: String) {
        let model: RepositoryListModel = .init()
        let presenter: RepositoryListPresenter = .init(model, userInfo: (id: id, login: login))
        let vc: RepositoryListViewController = .init(with: .init(input: presenter))
        self.navigationController?.pushViewController(vc, animated: true)
    }

    var tableView: UITableView! {
        return self.usersTableView
    }
}

