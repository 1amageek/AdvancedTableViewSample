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
        user.name = "WWDC Extended Tokyo 2017"
        let image: UIImage = #imageLiteral(resourceName: "wwdc")
        let data: Data = UIImageJPEGRepresentation(image, 0.7)!
        let file: File = File(data: data)
        user.profileImage = file
        user.bio = "『WWDC Extended』とは、Appleが行なっている技術者向けカンファレンス「WWDC」のメインセッション（Keynote）をライブビューイングするイベントです。今回は通常のライブビューイングに加えて、前年の発表内容の振り返りや今年の発表内容予想を行うLT大会、FaceTimeを繋いで現地で参加しているヤフーエンジニアの生の感想などを聞いたりする企画を予定しています。また会場では、無料でアルコール、ソフトドリンク、軽食を提供させていただく予定です。いち早く最先端のAppleテクノロジーを吸収しエンジニアとしての知見を深め、また参加者同士の企業間の垣根を越えるコミュニケーションの場を提供します。"

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
