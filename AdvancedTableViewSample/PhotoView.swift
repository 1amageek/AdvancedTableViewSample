//
//  PhotoView.swift
//  AdvancedTableViewSample
//
//  Created by 1amageek on 2017/06/05.
//  Copyright © 2017年 Stamp Inc. All rights reserved.
//

import UIKit

class PhotoView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    
    class func view() -> PhotoView {
        return UINib(nibName: "PhotoView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PhotoView
    }

}
