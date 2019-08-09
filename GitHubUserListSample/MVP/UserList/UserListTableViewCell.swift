//
//  UserListTableViewCell.swift
//  GitHubUserListSample
//
//  Created by Tomohiro Imaizumi on 2019/08/05.
//  Copyright © 2019 imaizume. All rights reserved.
//

import UIKit

class UserListTableViewCell: UITableViewCell {

    static let identifier: String = .init(describing: UserListTableViewCell.self)

    static let nib: UINib = .init(nibName: identifier, bundle: nil)

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!

    private(set) var user: GitHubUser!

    func initialize(by user: GitHubUser) {
        self.user = user
        let url = URL(string: user.avatarUrl)
        self.userImageView.kf.setImage(with: url)

        self.loginLabel.text = user.login
    }
}
