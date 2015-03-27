//
//  TweetTableViewCell.swift
//  twitterHash
//
//  Created by Zackery leman on 3/15/15.
//  Copyright (c) 2015 Zackery leman. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell
{
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
   
    let urlColor = UIColor.blueColor()
    let userMentionsColor = UIColor.greenColor()
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    func updateUI() {
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        if let tweet = self.tweet {
            var text = tweet.text
            
            for _ in tweet.media {
                text += " 📷"
            }
            
            var attributedText = NSMutableAttributedString(string: text)
            attributedText.changeKeywordsColor(tweet.hashtags, color:  uicolorFromHex(0xD3D3D3))
            attributedText.changeKeywordsColor(tweet.urls, color: urlColor)
            attributedText.changeKeywordsColor(tweet.userMentions, color: uicolorFromHex(0xCC9900))
            
            attributedText.changeKeywordsColor(tweet.mediaMentions, color: urlColor)
            
            tweetTextLabel?.attributedText = attributedText
            
            tweetScreenNameLabel?.text = "\(tweet.user)"
            
            self.tweetProfileImageView?.image = nil
            if let profileImageURL = tweet.user.profileImageURL {
                dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
                    let imageData = NSData(contentsOfURL: profileImageURL)
                    dispatch_async(dispatch_get_main_queue()) {
                        if profileImageURL == tweet.user.profileImageURL {
                            if imageData != nil {
                                self.tweetProfileImageView?.image = UIImage(data: imageData!)
                            }
                        }
                    }
                }
            }
            
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
            
            if (tweet.hashtags.count + tweet.urls.count + tweet.userMentions.count + tweet.media.count) > 0 {
                accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            } else {
                accessoryType = UITableViewCellAccessoryType.None
                
            }
        }
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }

    
   
}

// MARK: - Extensions

private extension NSMutableAttributedString {
    func changeKeywordsColor(keywords: [Tweet.IndexedKeyword], color: UIColor) {
        for keyword in keywords {
            addAttribute(NSForegroundColorAttributeName, value: color, range: keyword.nsrange)
        }
    }
}



