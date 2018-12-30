//
//  PostVC.swift
//  TwitterClone
//
//  Created by Emmanuel  Ogbewe on 12/30/18.
//  Copyright © 2018 Emmanuel Ogbewe. All rights reserved.
//

import UIKit

class PostVC: UIViewController {

    @IBOutlet weak var dismiss: UIButton!
    @IBOutlet weak var share: UIButton!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var userImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        tweetTextView.becomeFirstResponder()
    }
    private func addTargets(){
        dismiss.addTarget(self, action: #selector(PostVC.dimissVC), for: .touchUpInside)
        share.addTarget(self, action: #selector(PostVC.postTweet), for: .touchUpInside)
    }
    
    @objc private func postTweet(){
        NetworkingService.sendTweetToDatabase(username: "eogbewe", senderId: "ID123", tweet: tweetTextView.text!) {
            self.dimissVC()
        }
    }
    
    @objc private func dimissVC(){
        self.dismiss(animated: true, completion: nil)
        view.endEditing(true)
    }
}

