//
//  User.swift
//  WhoToFollow
//
//  Created by Hideaki Ishii on 9/21/15.
//
//

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
        let randomOffset = String(arc4random_uniform(500))

        return self.apiClient.request(path: "users", params: ["since": randomOffset])
            .observeOn(Dependencies.sharedInstance.backgroundScheduler)
            .map { json in
                guard let json = json as? [AnyObject] else { fatalError("Cast failed") }
                return self.parseJSON(json)
            }.observeOn(Dependencies.sharedInstance.mainScheduler)
    }

    static func parseJSON(json: [AnyObject]) -> [User] {
        return json.map { result in
            guard let name = result["login"] as? String else { fatalError("Parse error") }
            guard let url = result["html_url"] as? String else { fatalError("Parse error") }
            guard let avatarUrl = result["avatar_url"] as? String else { fatalError("Parse error") }
            return User(name: name, url: url, avatarUrl: avatarUrl)
        }
    }

}
