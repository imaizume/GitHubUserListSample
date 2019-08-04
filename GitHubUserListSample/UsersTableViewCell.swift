//
//  UsersTableViewCell.swift
//  GitHubUserListSample
//
//  Created by Tomohiro Imaizumi on 2019/08/05.
//  Copyright © 2019 imaizume. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {
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
