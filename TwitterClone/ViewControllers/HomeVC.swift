//
//  HomeVC.swift
//  TwitterClone
//
//  Created by Emmanuel  Ogbewe on 12/29/18.
//  Copyright © 2018 Emmanuel Ogbewe. All rights reserved.
//

import UIKit
import FirebaseFirestore

class HomeVC: UIViewController {
    
    //Database
    lazy var db = Firestore.firestore()
    private var databaseRef : CollectionReference {
    return db.collection("tweets")
    }
    //Data
    private var tweets : [Tweet] = []
    private var postListener: ListenerRegistration?
    deinit {
        postListener?.remove()
    }
    
    //Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newTweetBtn: UIButton!
    
    //Indicator
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(HomeVC.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.lightGray
        refreshControl.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appearence()
        grabPosts()
        
    }
    
    @IBAction func newTweet(_ sender: Any) {
        self.performSegue(withIdentifier: "newTweet", sender: nil)
    }
    
    private func appearence(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(refreshControl)
        tableView.tableFooterView = UIView()
        view.backgroundColor = UIColor(rgb: 0xE2E8ED)
        tableView.estimatedRowHeight = 66
        tableView.rowHeight = UITableView.automaticDimension
    }
    private func grabPosts(){
        postListener = databaseRef.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            print(snapshot.count)
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
            }
        }
    }
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    private func addPostToTable(_ post: Tweet) {
        guard !tweets.contains(post) else {
            return
        }
        
        tweets.append(post)
        
        tweets = tweets.sorted{
            $0.sentDate.compare($1.sentDate) == .orderedDescending
        }
        
        guard let index = tweets.index(of: post) else {
            return
        }
        tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func updatePostInTable(_ post: Tweet) {
        guard let index = tweets.index(of: post) else {
            return
        }
        
        tweets[index] = post
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func removePostFromTable(_ post: Tweet) {
        guard let index = tweets.index(of: post) else {
            return
        }
        
        tweets.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func handleDocumentChange(_ change: DocumentChange) {
        print(change.document)
        guard let post = Tweet(document: change.document) else {
            return
        }
        switch change.type {
        case .added:
            addPostToTable(post)
            
        case .modified:
            updatePostInTable(post)
            
        case .removed:
            removePostFromTable(post)
        }
    }
}
extension HomeVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! PostCell
        cell.post = tweets[indexPath.row]
        return cell 
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
