//
//  RepositoryListPresenter.swift
//  GitHubUserListSample
//
//  Created by Tomohiro Imaizumi on 2019/08/07.
//  Copyright © 2019 imaizume. All rights reserved.
//

import Foundation
import UIKit

protocol RepositoryListPresenterInput: class {
    func setOutput(_ output: RepositoryListPresenterOutput)
    func fetchRepos()
}

protocol RepositoryListPresenterOutput: class {
    var collectionView: UICollectionView! { get }
}

class RepositoryListPresenter: NSObject {

    private let input: RepositoryListModelInput
    private weak var output: RepositoryListPresenterOutput?
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
        self.output?.collectionView.delegate = self
        self.output?.collectionView.dataSource = self
    }

    func fetchRepos() {
        self.input.fetchRepos(byLogin: self.userInfo.login)
    }
}

extension RepositoryListPresenter: RepositoryListModelOutput {
    func didFetchRepos() {
        self.output?.collectionView.reloadData()
    }
}

extension RepositoryListPresenter: UICollectionViewDelegate {
}

extension RepositoryListPresenter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let repo: GitHubRepogitory = self.input.repos[safe: indexPath.row] else {
            return UICollectionViewCell()
        }

        return RepositoryCollectionViewCell(with: .init(repo: repo))
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.input.repos.count
    }
}
