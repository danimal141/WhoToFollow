//
//  Dependencies.swift
//  WhoToFollow
//
//  Created by Hideaki Ishii on 9/22/15.
//
//

import RxSwift

class Dependencies {

    // MARK: - Properties

    let mainScheduler = MainScheduler.sharedInstance
    let backgroundScheduler: ImmediateSchedulerType = {
        let operationQueue = NSOperationQueue()
        operationQueue.maxConcurrentOperationCount = 2
        operationQueue.qualityOfService = NSQualityOfService.UserInitiated

        return OperationQueueScheduler(operationQueue: operationQueue)
    }()

    static let sharedInstance = Dependencies()

    // MARK: - Initializers

    private init() {}

}
