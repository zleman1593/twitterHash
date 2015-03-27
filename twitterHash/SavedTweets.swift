//
//  SavedTweets.swift
//  twitterHash
//
//  Created by Zackery leman on 3/26/15.
//  Copyright (c) 2015 Zleman. All rights reserved.
//

import Foundation


class SavedTweets {
    
    
    private struct Const {
        static let tweetsKey = "SavedTweets.tweets"
    }
    private let defaults = NSUserDefaults.standardUserDefaults()
    var tweets: [String] {
        get { return defaults.objectForKey(Const.tweetsKey) as? [String] ?? [] }
        set { defaults.setObject(newValue, forKey: Const.tweetsKey) }
    }
    

    
    
    func add(tweet: Tweet?) {
        
        if let tweetToAdd = tweet? {
        tweets.append("@\(tweet!.user.screenName): \(tweet!.text)")
        }

        
    }
    
    
    func removeAtIndex(index: Int) {
        var currentTweets = tweets
        currentTweets.removeAtIndex(index)
        tweets = currentTweets

    }
    
    
    func removeAll(){
        tweets = []
    }
    
    
}


