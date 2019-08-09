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

protocol RepositoryListPresenterInput: class {
    func setOutput(_ output: RepositoryListPresenterOutput)
    func fetchRepoOwner()
    func fetchRepos()
}

protocol RepositoryListPresenterOutput: class {
    var ownerViews: (avatarImageView: UIImageView, loginLabel: UILabel, nameLabel: UILabel, followLabel: UILabel) { get }
    var collectionView: UICollectionView! { get }
    func open(_ viewController: UIViewController)
}

class RepositoryListPresenter: NSObject {

    private let input: RepositoryListModelInput
    private weak var output: RepositoryListPresenterOutput? {
        didSet {
            self.output?.collectionView.emptyDataSetSource = self
            self.output?.collectionView.emptyDataSetDelegate = self
        }
    }
    private let userInfo: (id: Int, login: String)

    required init(
        _ input: RepositoryListModelInput,
        userInfo: (id: Int, login: String)) {
        self.input = input
        self.userInfo = userInfo
        super.init()
        self.input.setOutput(self)
    }
}

extension RepositoryListPresenter: RepositoryListPresenterInput {
    func setOutput(_ output: RepositoryListPresenterOutput) {
        self.output = output
        self.output?.collectionView.register(UINib(nibName: RepositoryCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: RepositoryCollectionViewCell.identifier)
        self.output?.collectionView.delegate = self
        self.output?.collectionView.dataSource = self
    }

    func fetchRepoOwner() {
        self.input.fetchRepoOwner(byId: self.userInfo.id)
    }

    func fetchRepos() {
        self.input.fetchRepos(byLogin: self.userInfo.login)
    }
}

extension RepositoryListPresenter: RepositoryListModelOutput {
    func didFetchRepoOwner() {
        guard let owner = self.input.repoOwner else { return }
        self.output?.ownerViews.avatarImageView.kf.setImage(with: URL(string: owner.avatarUrl))
        self.output?.ownerViews.loginLabel.text = owner.login
        self.output?.ownerViews.nameLabel.text = owner.name
        let following: Int = owner.following
        let followers: Int = owner.followers
        self.output?.ownerViews.followLabel.text = "Following: \(following) / Followers: \(followers)"
    }

    func didFetchRepos() {
        DispatchQueue.main.async {
             self.output?.collectionView.reloadData()
        }
    }
}

extension RepositoryListPresenter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let repo: GitHubRepogitory = self.input.repos[safe: indexPath.row],
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
        guard let repo: GitHubRepogitory = self.input.repos[safe: indexPath.row] else {
            return UICollectionViewCell()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RepositoryCollectionViewCell.identifier, for: indexPath) as! RepositoryCollectionViewCell
        cell.repo = repo
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.input.repos.count
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
}

extension RepositoryListPresenter: DZNEmptyDataSetDelegate {
}
