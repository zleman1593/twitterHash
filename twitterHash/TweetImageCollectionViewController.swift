
//
//  TweetImageCollectionViewController.swift
//  twitterHash
//
//  Created by Zackery leman on 3/26/15.
//  Copyright (c) 2015 Zleman. All rights reserved.
//

import UIKit

class TweetImageCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    //Storyboard Constants
    private struct Storyboard {
        static let TweetImageCellReuseIdentifier = "TweetImageGridCell"
        static let TweetSegueIdentifier = "TweetFromImage"
        static let CellArea: CGFloat = 4000
    }
    
    var tweets: [[Tweet]] = [] {
        didSet {
            images = tweets.reduce([], +)
                .map { tweet in
                    tweet.media.map { TweetMedia(tweet: tweet, media: $0) }
                }.reduce([], +)
        }
    }
    
    var images = [TweetMedia]()
    
    struct TweetMedia {
        var tweet: Tweet
        var media: MediaItem
    }
    
    var cache = NSCache()
    
    var scale: CGFloat = 1 { didSet { collectionView?.collectionViewLayout.invalidateLayout() } }
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: "zoom:"))
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        tweets = appDelegate.tweets!
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        tweets = appDelegate.tweets!
    }
    
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.TweetImageCellReuseIdentifier, forIndexPath: indexPath) as TweetImageGridCell
        
        cell.cache = cache
        cell.imageURL = images[indexPath.row].media.url
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let ratio = CGFloat(images[indexPath.row].media.aspectRatio)
        let width = min(sqrt(ratio * Storyboard.CellArea) * scale, collectionView.bounds.size.width)
        let height = width / ratio
        return CGSize(width: width, height: height)
    }
    
 
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        super.willRotateToInterfaceOrientation(toInterfaceOrientation, duration: duration)
        collectionView?.collectionViewLayout.invalidateLayout()
    }

    
    // MARK:Gestures
    
    func zoom(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            scale *= gesture.scale
            gesture.scale = 1.0
        }
    }
    
    // MARK: - Segue Handling
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Segue to the tweet details assoiated with the selected image
        if let identifier = segue.identifier {
            if  identifier == Storyboard.TweetSegueIdentifier {
                if let ivc = segue.destinationViewController as? TweetDetailTableViewController {
                    if let cell = sender as? TweetImageGridCell {
                        ivc.tweet = images[collectionView!.indexPathForCell(cell)!.row].tweet
                    }
                }
            }
        }
        
    }
    
    
}
