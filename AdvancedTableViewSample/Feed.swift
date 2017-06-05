//
//  Feed.swift
//  AdvancedTableViewSample
//
//  Created by 1amageek on 2017/06/05.
//  Copyright © 2017年 Stamp Inc. All rights reserved.
//

import Foundation

class Feed: Object {

    @objc enum ContentType: Int {
        case unknown
        case photo
        case movie
    }

    dynamic var userID: String?
    dynamic var contentType: ContentType = .unknown
    dynamic var contentID: String?
    dynamic var likeCount: Int = 0

    override func encode(_ key: String, value: Any?) -> Any? {
        if key == "contentType" {
            return self.contentType.rawValue as Int
        }
        return nil
    }

    override func decode(_ key: String, value: Any?) -> Any? {
        if key == "contentType" {
            if let type: Int = value as? Int {
                self.contentType = ContentType(rawValue: type)!
                return self.contentType
            }
        }
        return nil
    }

}
