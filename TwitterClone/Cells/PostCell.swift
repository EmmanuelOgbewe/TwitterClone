//
//  PostCell.swift
//  TwitterClone
//
//  Created by Emmanuel  Ogbewe on 12/29/18.
//  Copyright © 2018 Emmanuel Ogbewe. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var tweet: UILabel!
    
    var post : Tweet! {
        didSet{
            userImage.image = UIImage(named: "max-bender-572807-unsplash")
            let tweetDate = post.sentDate.timeAgoDisplay()
            let fullText = "@jesse \(tweetDate) \n\(post.tweet)"
            let colorUsername = "@jesse"
            let colorDate = tweetDate
            let range1 = (fullText as NSString).range(of:colorUsername)
            let range2 = (fullText as NSString).range(of:colorDate)
            let attribute = NSMutableAttributedString.init(string: fullText)
            attribute.addAttributes([NSAttributedString.Key.font : UIFont(name: "Avenir-Heavy", size: 17)!, NSAttributedString.Key.foregroundColor : UIColor.black ], range: range1)
            attribute.addAttributes([NSAttributedString.Key.font : UIFont(name: "Avenir-Medium", size: 16)!, NSAttributedString.Key.foregroundColor : UIColor.init(rgb: 0xB8BFC4) ], range: range2)
            self.tweet.attributedText = attribute
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
}
