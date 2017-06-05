//
//  UserView.swift
//  AdvancedTableViewSample
//
//  Created by 1amageek on 2017/06/05.
//  Copyright © 2017年 Stamp Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorageUI

class UserView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!

    class func view() -> UserView {
        return UINib(nibName: "UserView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UserView
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.layer.cornerRadius = 60
        self.imageView.image = #imageLiteral(resourceName: "account")
    }

    var reloadBlock: (() -> Void)?

    var userID: String? {
        didSet {
            guard let userID: String = userID else {
                return
            }
            User.observeSingle(userID, eventType: .value) { (user) in
                guard let user: User = user else {
                    return
                }

                self.nameLabel.text = user.name
                self.bioLabel.text = user.bio

                if let ref: StorageReference = user.profileImage?.ref {
                    self.imageView.sd_setImage(with: ref, placeholderImage: #imageLiteral(resourceName: "account"))
                }
                self.setNeedsLayout()
                self.reloadBlock?()
            }
        }
    }
}
