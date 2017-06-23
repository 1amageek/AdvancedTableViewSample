//
//  SampleMaker.swift
//  AdvancedTableViewSample
//
//  Created by 1amageek on 2017/06/05.
//  Copyright © 2017年 Stamp Inc. All rights reserved.
//

import Firebase

class SampleMaker {

    func start(block: @escaping (String?, Error?) -> Void) {

        let user: User = User()
        user.name = "Otemachi Firebase #2"
        let image: UIImage = #imageLiteral(resourceName: "wwdc")
        let data: Data = UIImageJPEGRepresentation(image, 0.7)!
        let file: File = File(data: data)
        user.profileImage = file
        user.bio = "Firebaseの知見を共有しよう！"

        user.save { (ref, error) in
            if let error = error {
                debugPrint(error)
                block(nil, error)
                return
            }
            block(ref!.key, nil)
        }

    }


    func make(userID: String) {

        // User find
        User.observeSingle(userID, eventType: .value) { (user) in
            guard let user: User = user else {
                return
            }

            // Make photo sample
            (0..<6).forEach { (index) in
                let name: String = "\(index)"
                let image: UIImage = UIImage(named: name)!
                let data: Data = UIImageJPEGRepresentation(image, 0.7)!
                let file: File = File(data: data)

                let photo: Photo = Photo()
                photo.text = "This picture \(index) is very beautiful "
                photo.data = file
                photo.save({ (ref, error) in
                    if let error = error {
                        debugPrint(error)
                        return
                    }

                    // relationship to user
                    user.photoIDs.insert(ref!.key)

                    // Make Feed sample
                    let feed: Feed = Feed()
                    feed.userID = user.key
                    feed.contentType = .photo
                    feed.contentID = ref!.key
                    feed.save({ (ref, error) in
                        if let error = error {
                            debugPrint(error)
                            return
                        }

                        // relationship to user
                        user.feedIDs.insert(ref!.key)
                    })
                })
            }
        }
    }
}
