//
//  RepositoryCollectionViewCell.swift
//  GitHubUserListSample
//
//  Created by Tomohiro Imaizumi on 2019/08/07.
//  Copyright © 2019 imaizume. All rights reserved.
//

import ExpandableLabel
import Instantiate
import InstantiateStandard
import UIKit

class RepositoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var stargazerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: ExpandableLabel! {
        didSet {
            self.descriptionLabel.numberOfLines = 3
            self.descriptionLabel.collapsedAttributedLink = .init(string: "")

        }
    }

    static let identifier: String = .init(describing: RepositoryCollectionViewCell.self)

    var repo: GitHubRepogitory? {
        didSet {
            self.nameLabel.text = self.repo?.name
            if let language: String = self.repo?.language {
                self.languageLabel.text = "(\(language))"
            } else {
                self.languageLabel.text = ""
            }
            self.stargazerLabel.text = "⭐️\(self.repo?.stargazersCount ?? 0)"
            self.descriptionLabel.text = self.repo?.description ?? ""
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
