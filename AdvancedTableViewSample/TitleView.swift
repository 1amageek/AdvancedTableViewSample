//
//  TitleView.swift
//  AdvancedTableViewSample
//
//  Created by 1amageek on 2017/06/05.
//  Copyright © 2017年 Stamp Inc. All rights reserved.
//

import UIKit

class TitleView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    class func view() -> TitleView {
        return UINib(nibName: "TitleView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TitleView
    }

}
