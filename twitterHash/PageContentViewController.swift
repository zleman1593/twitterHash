//
//  PageContentViewController.swift
//  Lexii
//
//  Created by Zackery leman on 3/23/15.
//  Copyright (c) 2015 Zleman. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {

    @IBOutlet weak var imageText: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var pageIndex: Int?
    var titleText : String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageText.text = self.titleText
        self.imageText.alpha = 0.1
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.imageText.alpha = 1.0
        })
        
    }
    
    
    
    var cache: NSCache?
    
    var imageURL: NSURL? {
        didSet {
            image = nil
            fetchImage()
        }
    }
    
    
    private var image: UIImage? {
        get { return backgroundImage.image }
        set {
            backgroundImage?.image = newValue

        }
    }
    
    private func fetchImage() {
        if let url = imageURL {

            
            var imageData = cache?.objectForKey(url) as? NSData
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
