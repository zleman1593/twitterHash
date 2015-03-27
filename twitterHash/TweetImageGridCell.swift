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
            
            
            var imageData = cache?.objectForKey(url) as? NSData
            //If image has already been stored in the cache then set the image to the cached image
            if imageData != nil {
                self.image = UIImage(data: imageData!)
                return
            }
            
            //Else, load the image off the network not on the main thread
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
                imageData = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()) {
                    
                    //If the image is still the image being requested
                    if url == self.imageURL {
                        if imageData != nil {
                            self.image = UIImage(data: imageData!)
                            //Store the image in the cache
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
