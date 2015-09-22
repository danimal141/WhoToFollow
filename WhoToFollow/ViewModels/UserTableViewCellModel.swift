//
//  UserTableViewCellModel.swift
//  WhoToFollow
//
//  Created by Hideaki Ishii on 9/22/15.
//
//

import RxSwift

class UserTableViewCellModel {

    // MARK: - Properties
    
    let model: Variable<User>
    let name: Observable<String>
    let avatarUrl: Observable<NSURL>

    let disposeBag = DisposeBag()


    // MARK: - Initializers

    init(model: User) {
        self.model = Variable(model)
        self.name = self.model.map { return $0.name }
        self.avatarUrl = self.model.map { return NSURL(string: $0.avatarUrl)! }
    }

}
