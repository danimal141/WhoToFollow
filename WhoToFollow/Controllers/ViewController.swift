//
//  ViewController.swift
//  WhoToFollow
//
//  Created by Hideaki Ishii on 9/20/15.
//
//

import UIKit
import Alamofire
import RxSwift

class ViewController: UIViewController {

    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        GithubAPIClient.sharedInstance.request(path: "users")
            .subscribe(next: { print($0) }).addDisposableTo(self.disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
