//
//  UserTableViewCell.swift
//  WhoToFollow
//
//  Created by Hideaki Ishii on 9/22/15.
//
//

import UIKit
import RxSwift

class UserTableViewCell: UITableViewCell {

    // MARK: - Properties

    let disposeBag = DisposeBag()

    var viewModel: UserTableViewCellModel? {
        didSet {
            guard let vModel = self.viewModel else { return }

            vModel.name.bindTo(self.nameLabel.rx_text).addDisposableTo(self.disposeBag)
            vModel.avatarUrl.subscribeNext {
                self.avatarImageView.sd_setImageWithURL($0)
            }.addDisposableTo(self.disposeBag)
        }
    }

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
