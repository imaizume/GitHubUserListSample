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

class RepositoryListViewController: UIViewController {

    private var id: Int = 0

    private lazy var presenter: RepositoryListPresenterInput = RepositoryListPresenter(RepositoryListModel(), userInfo: (0, ""))
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followLabel: UILabel!
    @IBOutlet weak var repositoryCollectionView: UICollectionView!

    override func loadView() {
        super.loadView()
        self.title = "Repository List"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.setOutput(self)
        self.presenter.fetchRepoOwner()
        self.presenter.fetchRepos()
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

extension RepositoryListViewController: StoryboardInstantiatable {
    struct Dependency {
        let input: RepositoryListPresenterInput
    }

    func inject(_ dependency: Dependency) {
        self.presenter = dependency.input
    }
}
