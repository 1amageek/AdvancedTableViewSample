
//
//  DetailView.swift
//  AdvancedTableViewSample
//
//  Created by 1amageek on 2017/06/05.
//  Copyright © 2017年 Stamp Inc. All rights reserved.
//

import UIKit

class DetailView: UIView {

    @IBOutlet weak var detailLabel: UILabel!

    class func view() -> DetailView {
        return UINib(nibName: "DetailView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DetailView
    }


}
