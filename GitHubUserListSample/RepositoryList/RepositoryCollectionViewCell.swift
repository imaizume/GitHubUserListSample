//
//  RepositoryCollectionViewCell.swift
//  GitHubUserListSample
//
//  Created by Tomohiro Imaizumi on 2019/08/07.
//  Copyright © 2019 imaizume. All rights reserved.
//

import Instantiate
import InstantiateStandard
import UIKit

class RepositoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!

    static let identifier: String = .init(describing: UserListTableViewCell.self)

    private var repo: GitHubRepogitory? {
        didSet {
            self.nameLabel.text = self.repo?.name
        }
    }
}

extension RepositoryCollectionViewCell: NibInstantiatable {
    struct Dependency {
        let repo: GitHubRepogitory
    }

    func inject(_ dependency: RepositoryCollectionViewCell.Dependency) {
        self.repo = dependency.repo
    }
}
