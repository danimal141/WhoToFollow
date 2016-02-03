//
//  UserTableViewController.swift
//  WhoToFollow
//
//  Created by Hideaki Ishii on 9/21/15.
//
//

import UIKit
import RxSwift
import SafariServices

class UserTableViewController: UITableViewController, SFSafariViewControllerDelegate {

    // MARK: - Properties

    let disposeBag = DisposeBag()
    var users: [User] = [] {
        didSet { self.tableView.reloadData() }
    }

    private var cellIdentifier: String!


    // MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()

        self.adjustContentInsetTop()
        self.registerCell("UserTableViewCell", identifier: "UserTableViewCell")

        self.subscribe()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath: indexPath) as! UserTableViewCell

        if let user = self.userForIndexPath(indexPath) {
            cell.viewModel = UserTableViewCellModel(model: user)
        }
        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UserTableViewCell.rowHeight
    }


    // MARK: - Instance methods

    private func subscribe() {
        [
            self.refreshControl!.rx_controlEvents(.ValueChanged)
                .startWith({ print("Start loading...") }())
                .flatMap { return User.fetch() }
                .subscribeNext { [weak self] result in
                    self?.users = result
                    self?.refreshControl!.endRefreshing()
                },

            self.tableView.rx_itemDeleted.subscribeNext { [weak self] indexPath in
                self?.switchUserForIndexPath(indexPath)
            },

            self.tableView.rx_itemSelected.subscribeNext { [weak self] indexPath in
                self?.showUserProfile(indexPath)
            },
        ].forEach { $0.addDisposableTo(self.disposeBag) }
    }

    private func userForIndexPath(indexPath: NSIndexPath) -> User? {
        if indexPath.section != 0 || self.users.count <= indexPath.item { return nil }
        return self.users[indexPath.item]
    }

    private func adjustContentInsetTop() {
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        let navBarHeight = self.navigationController!.navigationBar.frame.size.height

        self.tableView.contentInset.top = statusBarHeight + navBarHeight
    }

    private func registerCell(nibName: String, identifier: String) {
        let nib = UINib(nibName: nibName, bundle: nil)

        self.tableView.registerNib(nib, forCellReuseIdentifier: identifier)
        self.cellIdentifier = identifier
    }

    private func switchUserForIndexPath(indexPath: NSIndexPath) {
        var data = self.users
        let nextIndex = Int(arc4random_uniform(18) + 11) // Select from remaining users
        let prevData = data[indexPath.row]

        data[indexPath.item] = data[nextIndex]
        data[nextIndex] = prevData
        self.users = data
    }

    private func showUserProfile(indexPath: NSIndexPath) {
        guard let user = self.userForIndexPath(indexPath) else { return }
        guard let url = NSURL(string: user.url) else { return }

        if #available(iOS 9.0, *) {
            let safari = SFSafariViewController(URL: url)
            safari.delegate = self
            self.presentViewController(safari, animated: true, completion: nil)
        } else {
            UIApplication.sharedApplication().openURL(url)
        }

        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }

}
