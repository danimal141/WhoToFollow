//
//  UserTableViewController.swift
//  WhoToFollow
//
//  Created by Hideaki Ishii on 9/21/15.
//
//

import UIKit
import RxSwift
import SDWebImage

class UserTableViewController: UITableViewController {

    // MARK: - Properties

    let disposeBag = DisposeBag()

    var users: [User] = [] {
        didSet { self.tableView.reloadData() }
    }


    // MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.contentInset.top = 40

        guard let control = self.refreshControl else { return }
        control.rx_controlEvents(.ValueChanged).startWith({ print("Start loading...") }())
            .flatMap {
                return User.fetch()
            }.subscribeNext { [unowned self] result in
                self.users = result
                control.endRefreshing()
            }.addDisposableTo(self.disposeBag)

        self.tableView.rx_itemDeleted.subscribeNext { [unowned self] indexPath in
            var data = self.users
            let nextIndex = Int(arc4random_uniform(18) + 11) // Select from remaining users
            let prevData = data[indexPath.row]

            data[indexPath.row] = data[nextIndex]
            data[nextIndex] = prevData
            self.users = data
        }.addDisposableTo(self.disposeBag)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("UserTableCell", forIndexPath: indexPath)

        if let user = self.userForIndexPath(indexPath) {
            let url = NSURL(string: user.avatarUrl)

            cell.imageView?.sd_setImageWithURL(url)
            cell.textLabel?.text = user.name
        }
        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }


    // MARK: - Instance methods

    func userForIndexPath(indexPath: NSIndexPath) -> User? {
        if indexPath.section != 0 || self.users.count <= indexPath.item { return nil }
        return self.users[indexPath.item]
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
