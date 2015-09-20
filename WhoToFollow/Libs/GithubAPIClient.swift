//
//  GithubAPIClient.swift
//  WhoToFollow
//
//  Created by Hideaki Ishii on 9/20/15.
//
//

import Alamofire
import RxSwift
import RxCocoa

protocol APIClient: class {
    func request(method: Alamofire.Method, path: String, params: [String: String]) -> Observable<AnyObject!>
}

class GithubAPIClient: APIClient {

    // MARK: - Properties

    let scheme = "https"
    let host: String = "api.github.com"
    let mainScheduler: SerialDispatchQueueScheduler = MainScheduler.sharedInstance
    let backgroundScheduler: ImmediateSchedulerType = {
        let operationQueue = NSOperationQueue()
        operationQueue.maxConcurrentOperationCount = 2
        operationQueue.qualityOfService = NSQualityOfService.UserInitiated

        return OperationQueueScheduler(operationQueue: operationQueue)
    }()

    private let manager = Alamofire.Manager.sharedInstance

    static let sharedInstance: GithubAPIClient = GithubAPIClient()


    // MARK: - Instance methods

    func request(method: Alamofire.Method = .GET, path: String, params: [String : String] = [:]) -> Observable<AnyObject!> {
        let request = self.manager.request(method, self.buildPath(path), parameters: params).request

        if let request = request  {
            return self.manager.session.rx_JSON(request)
        } else {
            fatalError("Invalid request")
        }
    }


    // MARK: - Private methods

    private func buildPath(path: String) -> NSURL {
        let trimmedPath = path.hasPrefix("/") ? path.substringFromIndex(path.startIndex.successor()) : path
        return NSURL(scheme: self.scheme, host: self.host, path: "/" + trimmedPath)!
    }

}
