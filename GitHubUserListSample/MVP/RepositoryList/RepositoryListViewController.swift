//
//  RepositoryListViewController.swift
//  GitHubUserListSample
//
//  Created by Tomohiro Imaizumi on 2019/08/07.
//  Copyright © 2019 imaizume. All rights reserved.
//

import Instantiate
import InstantiateStandard
import UIKit

/**
 ユーザー一覧からセルタップ後に遷移するリポジトリのリスト
 */
class RepositoryListViewController: UIViewController {

    // MARK: - Properties

    // MARK: IBOutlet

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var loginLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var followLabel: UILabel!
    @IBOutlet private weak var repositoryCollectionView: UICollectionView!
    @IBOutlet internal weak var activityIndicatorView: UIActivityIndicatorView!

    // MARK: private

    private var userInfo: (id: Int, login: String)!

    private var presenter: RepositoryListPresenter!

    // MARK: - Methods

    // MARK: lifecycle

    override func loadView() {
        super.loadView()
        self.title = "Repository List"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = .init(self, userInfo: self.userInfo)
        self.presenter.fetchRepoOwner()
        self.presenter.fetchRepos()
    }
}

extension RepositoryListViewController: StoryboardInstantiatable {
    struct Dependency {
        let userInfo: (id: Int, login: String)
    }

    func inject(_ dependency: Dependency) {
        self.userInfo = dependency.userInfo
    }
}

extension RepositoryListViewController: RepositoryListPresenterOutput {
    var ownerViews: (avatarImageView: UIImageView, loginLabel: UILabel, nameLabel: UILabel, followLabel: UILabel) {
        return (self.avatarImageView, self.loginLabel, self.nameLabel, self.followLabel)
    }

    func open(_ viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    var collectionView: UICollectionView! {
        return self.repositoryCollectionView
    }
}
