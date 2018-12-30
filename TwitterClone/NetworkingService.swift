//
//  NetworkingService.swift
//  TwitterClone
//
//  Created by Emmanuel  Ogbewe on 12/29/18.
//  Copyright © 2018 Emmanuel Ogbewe. All rights reserved.
//

import Foundation
import UIKit
import Foundation
import FirebaseStorage
import FirebaseFirestore


class NetworkingService {
    
    static func sendTweetToDatabase( username : String , senderId: String, tweet: String, onSuccess: @escaping () -> Void) {
        
        let db = Firestore.firestore()
        let postRef = db.collection("tweets").document()
        
        let dict = ["username" : username, "tweet": tweet, "created" : Date(), "senderId" : senderId] as [String : Any]
       
        postRef.setData(dict) { (err) in
            if err != nil {
                print(err!.localizedDescription)
            }else{
                onSuccess()
            }
        }
    }
    
}
