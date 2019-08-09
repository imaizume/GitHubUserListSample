//
//  RepositoryListModel.swift
//  GitHubUserListSample
//
//  Created by Tomohiro Imaizumi on 2019/08/07.
//  Copyright © 2019 imaizume. All rights reserved.
//

import Foundation

protocol RepositoryListModelOutput: class {
    func didFetchRepoOwner()
    func didFetchRepos()
}

class RepositoryListModel: NSObject {

    private(set) weak var output: RepositoryListModelOutput?

    private(set) var repoOwner: GitHubUser? {
        didSet {
            self.output?.didFetchRepoOwner()
        }
    }

    private(set) var repos: [GitHubRepo] = [] {
        didSet {
             self.output?.didFetchRepos()
        }
    }

    /// APIコール中であれば `true` になる
    private(set) var isLoading: Bool = false

    required init(_ output: RepositoryListModelOutput) {
        self.output = output
    }

    func fetchRepoOwner(byId id: Int) {
        GitHubUser.fetch(byId: id) { errorOrOwner in
            switch errorOrOwner {
            case let .left(error):
                print(error)
                // TODO: assert error
            case let .right(owner):
                self.repoOwner = owner
            }
        }
    }

    func fetchRepos(byLogin login: String) {
        guard !self.isLoading else { return }
        self.startLoading()
        GitHubRepo.fetch(byLogin: login) { errorOrRepos in
            switch errorOrRepos {
            case let .left(error):
                print(error)
                // TODO: assert error
            case let .right(repos):
                self.repos.append(contentsOf: repos)
            }
            self.finishLoading()
        }
    }

    // MARK: private

    /// APIコール状態をONにする
    private func startLoading() { self.isLoading = true }

    /// APIコール状態をOFFにする
    private func finishLoading() { self.isLoading = false }
}
