//
//  ActionView.swift
//  AdvancedTableViewSample
//
//  Created by 1amageek on 2017/06/05.
//  Copyright © 2017年 Stamp Inc. All rights reserved.
//

import UIKit

class ActionView: UIView {

    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBAction func action(_ sender: Any) {
        self.actionButton.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.3, options: UIViewAnimationOptions.curveEaseInOut, animations: { 
            self.actionButton.transform = CGAffineTransform.identity
        }, completion: nil)
        self.actionBlock?()
    }

    var actionBlock: (() -> Void)?

    class func view() -> ActionView {
        return UINib(nibName: "ActionView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ActionView
    }

}
