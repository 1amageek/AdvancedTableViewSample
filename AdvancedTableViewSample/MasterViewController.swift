//
//  MasterViewController.swift
//  AdvancedTableViewSample
//
//  Created by 1amageek on 2017/05/31.
//  Copyright © 2017年 Stamp Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorageUI

class MasterViewController: UITableViewController {

    var datasource: DataSource<User, Feed>?

    var userID: String? {
        didSet {
            guard let userID: String = userID else {
                return
            }
            self.headerView.userID = userID
        }
    }

    @IBAction func createUser(_ sender: Any) {
        self.sampleMaker.start { (userID, error) in
            self.userID = userID

            guard let userID: String = userID else {
                return
            }

            let options: SaladaOptions = SaladaOptions()
            options.limit = 10
            options.ascending = false
            self.datasource = DataSource(parentKey: userID,
                                         referenceKey: "feedIDs",
                                         options: options,
                                         block: { [weak self](changes) in
                guard let tableView: UITableView = self?.tableView else { return }

                switch changes {
                case .initial:
                    tableView.reloadData()
                case .update(let deletions, let insertions, let modifications):
                    tableView.beginUpdates()
                    tableView.insertRows(at: insertions.map { IndexPath(item: 0, section: $0) }, with: .automatic)
                    tableView.deleteRows(at: deletions.map { IndexPath(item: 0, section: $0) }, with: .automatic)
                    tableView.reloadRows(at: modifications.map { IndexPath(item: 0, section: $0) }, with: .automatic)
                    tableView.insertSections(IndexSet(insertions), with: .automatic)
                    tableView.deleteSections(IndexSet(deletions), with: .automatic)
                    tableView.reloadSections(IndexSet(modifications), with: .automatic)
                    tableView.endUpdates()
                case .error(let error):
                    print(error)
                }
            })
        }
    }

    @IBAction func createSample(_ sender: Any) {
        guard let userID: String = userID else {
            return
        }
        self.sampleMaker.make(userID: userID)
    }

    let headerView: UserView = UserView.view()

    let sampleMaker: SampleMaker = SampleMaker()

    override func loadView() {
        super.loadView()
        self.title = "Advanced Table View"
        self.tableView.tableHeaderView = self.headerView
        self.tableView.estimatedRowHeight = 300
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.headerView.reloadBlock = { [weak self] in
            self?.tableView.tableHeaderView = nil
            self?.headerView.layoutIfNeeded()
            self?.tableView.tableHeaderView = self?.headerView
        }
    }

    let dateFormatter: DateFormatter = {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/M/d"
        return dateFormatter
    }()

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.datasource?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        configure(cell: cell, at: indexPath)
        return cell
    }

    func configure(cell: TableViewCell, at indexPath: IndexPath) {
        self.datasource?.observeObject(at: indexPath.section, block: { (feed) in
            guard let feed: Feed = feed else {
                return
            }
            var likeCount: Int = feed.likeCount
            cell.actionView.likeCountLabel.text = String(likeCount)
            cell.actionView.actionBlock = {
                likeCount += 1
                cell.actionView.likeCountLabel.text = String(likeCount)
                feed.likeCount = likeCount
            }

            // Get user data
            User.observeSingle(feed.userID!, eventType: .value, block: { (user) in
                guard let user: User = user else {
                    return
                }
                cell.titleView.titleLabel.text = user.name
                cell.titleView.dateLabel.text = self.dateFormatter.string(from: feed.updatedAt)
                if let ref: StorageReference = user.profileImage?.ref {
                    cell.titleView.imageView.sd_setImage(with: ref, placeholderImage: #imageLiteral(resourceName: "account"))
                }
            })

            // Switch content type
            switch feed.contentType {

            // Photo
            case .photo:

                // Get photo data
                Photo.observeSingle(feed.contentID!, eventType: .value, block: { (photo) in
                    guard let photo: Photo = photo else {
                        return
                    }
                    cell.detailView.detailLabel.text = photo.text
                    cell.setNeedsLayout()
                    if let ref: StorageReference = photo.data?.ref {
                        cell.photoView.imageView.sd_setImage(with: ref, placeholderImage: #imageLiteral(resourceName: "art_placeholder"))
                    }
                })

            // TODO: hide content
            default: break
            }

        })
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.datasource?.removeObserver(at: indexPath.section)
    }

    override func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.datasource?.removeObject(at: indexPath.section, cascade: true, block: { (key, error) in
                if let error: Error = error {
                    print(error)
                }
            })
        }
    }
}
