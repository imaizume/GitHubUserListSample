//
//  UserListPresenter.swift
//  GitHubUserListSample
//
//  Created by Tomohiro Imaizumi on 2019/08/05.
//  Copyright © 2019 imaizume. All rights reserved.
//

import UIKit

/**
 UserListPresenterの出力先に要求するインターフェイス
 */
protocol UserListPresenterOutput: class {

    /// ユーザー一覧を表示する `UITableView`
    var tableView: UITableView! { get }

    var activityIndicatorView: UIActivityIndicatorView! { get }

    /// ユーザーをセレクトした際の
    ///
    /// - parameters:
    ///   - id: GitHubのユーザーID
    ///   - login: GitHubのログイン名
    func didSelectItem(ofUserId id: Int, withLogin login: String)
}

/**
 ユーザー一覧画面の表示ロジックを担うpresenter
 */
class UserListPresenter: NSObject {
    weak var output: UserListPresenterOutput?

    private lazy var model: UserListModel = .init(self, withGitHubUser: GitHubUser.self)

    /// 画面をドラッグ中であれば `true` になる
    private var isDragging: Bool = false

    // MARK: - Methods

    // MARK: lifecycle

    required init(_ output: UserListPresenterOutput) {
        self.output = output
        super.init()
        self.output?.tableView.register(UserListTableViewCell.nib,
                                        forCellReuseIdentifier: UserListTableViewCell.identifier)
        self.output?.tableView.delegate = self
        self.output?.tableView.dataSource = self
        self.model.fetchUsers()
    }

    // MARK: internal

    /// ユーザー一覧を取得
    func fetchUsers() {
        self.output?.tableView.reloadData()
        self.output?.activityIndicatorView.startAnimating()
    }

    // MARK: private

    /// ドラッグ状態をONに更新する
    private func startDragging() { self.isDragging = true }

    /// ドラッグ状態をOFFにする
    private func finishDragging() { self.isDragging = false }
}

extension UserListPresenter: UserListModelOutput {
    func didFetchUsers() {
        DispatchQueue.main.async {
            self.output?.tableView.reloadData()
            self.output?.activityIndicatorView.stopAnimating()
        }
    }
}

extension UserListPresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! UserListTableViewCell
        self.output?.didSelectItem(ofUserId: cell.user.id, withLogin: cell.user.login)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension UserListPresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let user: GitHubUser = self.model.users[safe: indexPath.row] else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: UserListTableViewCell.identifier, for: indexPath) as! UserListTableViewCell
        cell.initialize(by: user)
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.users.count
    }
}

extension UserListPresenter: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height: CGFloat = scrollView.frame.size.height
        let distanceFromBottom: CGFloat = scrollView.contentSize.height - scrollView.contentOffset.y
        if distanceFromBottom < height && self.isDragging {
            self.model.fetchUsers()
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.startDragging()
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.finishDragging()
    }
}
