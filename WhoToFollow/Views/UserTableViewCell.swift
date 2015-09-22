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
                self.avatarImageView.sd_setImageWithURL($0, placeholderImage: UIImage(named: "DefaultImage.png"))
            }.addDisposableTo(self.disposeBag)
        }
    }

    static let rowHeight: CGFloat = 80


    // MARK: - IBOutlets

    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    

    // MARK: - Lifecycles

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.avatarImageView.frame = self.avatarView.bounds
    }

}
