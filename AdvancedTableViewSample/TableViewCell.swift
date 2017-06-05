//
//  TableViewCell.swift
//  AdvancedTableViewSample
//
//  Created by 1amageek on 2017/06/05.
//  Copyright © 2017年 Stamp Inc. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var stackView: UIStackView!

    let titleView: TitleView = TitleView.view()
    let detailView: DetailView = DetailView.view()
    let photoView: PhotoView = PhotoView.view()
    let actionView: ActionView = ActionView.view()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.stackView.addArrangedSubview(titleView)
        self.stackView.addArrangedSubview(detailView)
        self.stackView.addArrangedSubview(photoView)
        self.stackView.addArrangedSubview(actionView)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleView.titleLabel.text = " "
        self.titleView.dateLabel.text = " "
        self.titleView.imageView.image = #imageLiteral(resourceName: "account")
        self.detailView.detailLabel.text = " "
        self.photoView.imageView.image = #imageLiteral(resourceName: "art_placeholder")
        self.actionView.actionBlock = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {

    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {

    }

}
