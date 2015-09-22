//
//  UserTableViewCell.swift
//  WhoToFollow
//
//  Created by Hideaki Ishii on 9/22/15.
//
//

import UIKit

class UserTableViewCell: UITableViewCell {

    // MARK: - Properties

    // MARK: - IBOutlets

    @IBOutlet weak var avatarImageView: UIImageView! 
    @IBOutlet weak var nameLabel: UILabel!

    // MARK: - Lifecycles

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
