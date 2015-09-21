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

    let name: String
    let url: String
    let avatarUrl: String

    init(name: String, url: String, avatarUrl: String) {
        self.name = name
        self.url = url
        self.avatarUrl = avatarUrl
    }

}
