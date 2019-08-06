//
//  RepositoryListModel.swift
//  GitHubUserListSample
//
//  Created by Tomohiro Imaizumi on 2019/08/07.
//  Copyright © 2019 imaizume. All rights reserved.
//

import Foundation

protocol RepositoryListModelInput: class {
    func fetchRepos(byLogin login: String)

    var repos: [GitHubRepogitory] { get }

    func setOutput(_ output: RepositoryListModelOutput)
}

protocol RepositoryListModelOutput: class {
    func didFetchRepos()
}

class RepositoryListModel: NSObject {

    private(set) weak var output: RepositoryListModelOutput? = nil

    private(set) var repos: [GitHubRepogitory] = [] {
        didSet {
             self.output?.didFetchRepos()
        }
    }

    func setOutput(_ output: RepositoryListModelOutput) {
        self.output = output
    }
}

extension RepositoryListModel: RepositoryListModelInput {
    func fetchRepos(byLogin login: String) {
        GitHubRepogitory.fetch(byLogin: login) { errorOrRepos in
            switch errorOrRepos {
            case let .left(error):
                print(error)
                // TODO: assert error
                break
            case let .right(repos):
                self.repos.append(contentsOf: repos)
            }
        }
    }
}
