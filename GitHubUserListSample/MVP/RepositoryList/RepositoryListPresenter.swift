//
//  RepositoryListPresenter.swift
//  GitHubUserListSample
//
//  Created by Tomohiro Imaizumi on 2019/08/07.
//  Copyright © 2019 imaizume. All rights reserved.
//

import DZNEmptyDataSet
import Foundation
import Kingfisher
import UIKit

protocol RepositoryListPresenterOutput: class {
    var ownerViews: (avatarImageView: UIImageView, loginLabel: UILabel, nameLabel: UILabel, followLabel: UILabel) { get }
    var collectionView: UICollectionView! { get }
    var activityIndicatorView: UIActivityIndicatorView! { get }
    func open(_ viewController: UIViewController)
}

class RepositoryListPresenter: NSObject {

    private weak var output: RepositoryListPresenterOutput?

    private lazy var model: RepositoryListModel = .init(self)

    private let userInfo: (id: Int, login: String)

    required init(
        _ output: RepositoryListPresenterOutput,
        userInfo: (id: Int, login: String)) {

        self.output = output
        self.userInfo = userInfo
        super.init()

        guard let collectionView: UICollectionView = self.output?.collectionView else { return }
        collectionView.register(UINib(nibName: RepositoryCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: RepositoryCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
    }

    func fetchRepoOwner() {
        self.model.fetchRepoOwner(byId: self.userInfo.id)
    }

    func fetchRepos() {
        self.model.fetchRepos(byLogin: self.userInfo.login)
        self.output?.activityIndicatorView.startAnimating()
    }
}

extension RepositoryListPresenter: RepositoryListModelOutput {
    func didFetchRepoOwner() {
        guard let owner = self.model.repoOwner else { return }
        self.output?.ownerViews.avatarImageView.kf.setImage(with: URL(string: owner.avatarUrl))
        self.output?.ownerViews.loginLabel.text = owner.login
        self.output?.ownerViews.nameLabel.text = owner.name
        let following: Int = owner.following
        let followers: Int = owner.followers
        self.output?.ownerViews.followLabel.text = "Following: \(following) / Followers: \(followers)"
    }

    func didFetchRepos() {
        DispatchQueue.main.async {
            self.output?.activityIndicatorView.stopAnimating()
            self.output?.collectionView.reloadData()
        }
    }
}

extension RepositoryListPresenter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let repo: GitHubRepo = self.model.repos[safe: indexPath.row],
            let url = URL(string: repo.htmlUrl) else {
            // TODO: assertion
            return
        }
        let vc: WebViewController = .init(url)
        self.output?.open(vc)
    }
}

extension RepositoryListPresenter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let repo: GitHubRepo = self.model.repos[safe: indexPath.row] else {
            return UICollectionViewCell()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RepositoryCollectionViewCell.identifier, for: indexPath) as! RepositoryCollectionViewCell
        cell.repo = repo
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model.repos.count
    }
}

extension RepositoryListPresenter: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let h: CGFloat = 100
        let w: CGFloat = collectionView.frame.size.width - 20
        return CGSize(width: w, height: h)
    }
}

extension RepositoryListPresenter: DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return Asset.empty.image
    }

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(
            string: "No Repository Found",
            attributes: [
                .foregroundColor: UIColor.gray,
                .font: UIFont.boldSystemFont(ofSize: 20)
            ])
    }
}

extension RepositoryListPresenter: DZNEmptyDataSetDelegate {
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return !self.model.isLoading
    }

    // [8]
    func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}
