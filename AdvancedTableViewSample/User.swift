//
//  User.swift
//  AdvancedTableViewSample
//
//  Created by 1amageek on 2017/06/05.
//  Copyright © 2017年 Stamp Inc. All rights reserved.
//

import Foundation

class User: Object {

    dynamic var name: String?
    dynamic var profileImage: File?
    dynamic var bio: String?
    dynamic var feedIDs: Set<String> = []
    dynamic var photoIDs: Set<String> = []
    
}
