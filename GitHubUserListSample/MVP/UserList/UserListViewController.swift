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

/**
 GitHubのユーザー一覧
 */
class UserListViewController: UIViewController {

    // MARK: - Properties

    // MARK: IBOutlet

    @IBOutlet private weak var usersTableView: UITableView!

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    // MARK: private

    private var presenter: UserListPresenter!

    // MARK: - Methods

    // MARK: lifecycle

    override func loadView() {
        super.loadView()
        self.title = "Repository List"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = .init(self)
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
    func didSelectItem(ofUserId id: Int, withLogin login: String) {
        let vc: RepositoryListViewController = .init(with: .init(userInfo: (id: id, login: login)))
        self.navigationController?.pushViewController(vc, animated: true)
    }

    var tableView: UITableView! {
        return self.usersTableView
    }
}
