//
//  User.swift
//  WhoToFollow
//
//  Created by Hideaki Ishii on 9/21/15.
//
//

import Foundation
import RxSwift

class User {

    // MARK: - Properties

    let name: String
    let url: String
    let avatarUrl: String

    static let apiClient = GithubAPIClient.sharedInstance


    // MARK: - Initializers

    init(name: String, url: String, avatarUrl: String) {
        self.name = name
        self.url = url
        self.avatarUrl = avatarUrl
    }


    // MARK: - Static methods

    static func fetch() -> Observable<[User]> {
        return self.apiClient.request(path: "users")
            .observeOn(self.apiClient.backgroundScheduler)
            .map { json in
                guard let json = json as? [AnyObject] else { throw commonError("Cast failed") }
                return try self.parseJSON(json)
            }
            .observeOn(self.apiClient.mainScheduler)
    }

    static func parseJSON(json: [AnyObject]) throws -> [User] {
        return try json.map { result in
            guard let name = result["login"] as? String else { throw commonError("Parse error") }
            guard let url = result["html_url"] as? String else { throw commonError("Parse error") }
            guard let avatarUrl = result["avatar_url"] as? String else { throw commonError("Parse error") }

            return User(name: name, url: url, avatarUrl: avatarUrl)
        }
    }

}
