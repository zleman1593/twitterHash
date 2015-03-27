//
//  TweetImageGridCell.swift
//  twitterHash
//
//  Created by Zackery leman on 3/26/15.
//  Copyright (c) 2015 Zleman. All rights reserved.
//

import UIKit

class TweetImageGridCell: UICollectionViewCell {

    @IBOutlet weak var spinner: UIActivityIndicatorView!

    @IBOutlet weak var tweetImage: UIImageView!
    
    var cache: NSCache?
    
    var imageURL: NSURL? {
        didSet {
            backgroundColor = UIColor.darkGrayColor()
            image = nil
            fetchImage()
        }
    }
    
    
    private var image: UIImage? {
        get { return tweetImage.image }
        set {
            tweetImage.image = newValue
            spinner?.stopAnimating()
        }
    }
    
    private func fetchImage() {
        if let url = imageURL {
            spinner?.startAnimating()
            
            var imageData = cache?.objectForKey(imageURL!) as? NSData
            if imageData != nil {
                self.image = UIImage(data: imageData!)
                return
            }
            
            let qos = NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1 ? Int(QOS_CLASS_USER_INITIATED.value) : DISPATCH_QUEUE_PRIORITY_HIGH
            dispatch_async(dispatch_get_global_queue(qos, 0)) {
                imageData = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()) {
                    if url == self.imageURL {
                        if imageData != nil {
                            self.image = UIImage(data: imageData!)
                            self.cache?.setObject(imageData!, forKey: self.imageURL!, cost: imageData!.length / 1024)
                        } else {
                            self.image = nil
                        }
                    }
                }
            }
        }
    }
    
    
    
}
