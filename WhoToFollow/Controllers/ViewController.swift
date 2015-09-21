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
    let users = Variable([User]())

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        User.fetch()
            .subscribeNext { [unowned self] result in self.users.value = result }
            .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
