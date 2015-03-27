//
//  ImageCell.swift
//  twitterHash
//
//  Created by Zackery leman on 3/18/15.
//  Copyright (c) 2015 Zleman. All rights reserved.
//

import UIkit

class ImageCell: UITableViewCell {
    
    var imageUrl: NSURL? { didSet { updateUI() } }
    var imageData: NSData?
    @IBOutlet weak var tweetImage: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    func updateUI() {
        tweetImage?.image = nil
        if let url = imageUrl {
            spinner?.startAnimating()
            //Load image off main thread
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
                 self.imageData = NSData(contentsOfURL: url)
                //Once image has been downloaded, set image back on main thread
                dispatch_async(dispatch_get_main_queue()) {
                    //Make sure to only load this image if user is still requesting this image
                    if url == self.imageUrl {
                        if self.imageData != nil {
                            self.tweetImage?.image = UIImage(data: self.imageData!)
                        } else {
                            self.tweetImage?.image = nil
                        }
                        self.spinner?.stopAnimating()
                    }
                }
            }
        }
    }

}
