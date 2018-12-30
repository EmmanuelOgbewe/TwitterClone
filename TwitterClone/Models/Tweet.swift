//
//  Tweet.swift
//  TwitterClone
//
//  Created by Emmanuel  Ogbewe on 12/29/18.
//  Copyright © 2018 Emmanuel Ogbewe. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Tweet {
    
    let id: String?
    let username: String
    let senderId : String
    let tweet : String
    let sentDate: Date
    
    init(username: String, tweet:String, senderId: String) {
        id = nil
        self.username = username
        self.tweet = tweet
        self.senderId = senderId
        sentDate = Date()
        
    }
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let username = data["username"] as? String else {
            return nil
        }
        guard let tweet = data["tweet"] as? String else {
            return nil
        }
        guard let sentDate = data["created"] as? Date else {
            return nil
        }
        guard let senderId = data["senderId"] as? String else {
            return nil
        }
        
        id = document.documentID
        self.username = username
        self.sentDate = sentDate
        self.tweet = tweet
        self.senderId = senderId
        
    }
}

extension Tweet: DataRepresentation {
    var representation: [String : Any] {
        var rep: [String : Any] = ["username": username,"created": sentDate, "tweet": tweet, "senderId": senderId]
        
        if let id = id {
            rep["id"] = id
        }
        
        return rep
    }
}

extension Tweet: Comparable {
    
    static func == (lhs: Tweet, rhs: Tweet) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Tweet, rhs: Tweet) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
    
}



