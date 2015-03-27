//
//  TweetTableViewController.swift
//  twitterHash
//
//  Created by Zackery leman on 3/15/15.
//  Copyright (c) 2015 Zackery leman. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    @IBAction func unwindToRoot(sender: UIStoryboardSegue) { }
    var tweets:[[Tweet]] = [[Tweet]]() {
        didSet {
            let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            appDelegate.tweets = tweets
        }
    }
    
    var lastSuccessfulRequest: TwitterRequest?
    var nextRequestToAttempt: TwitterRequest? {
        if lastSuccessfulRequest == nil {
            if searchText != nil {
                var query = searchText!
                if query.hasPrefix("@"){
                    query = "\(query) OR from:\(query)"
                }
                return TwitterRequest(search: query, count: 100)
            } else {
                return nil
            }
        } else {
            return lastSuccessfulRequest!.requestForNewer
        }
    }
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
        
    }
    
    var searchText: String? = "#appleWatch" {
        didSet {
            lastSuccessfulRequest = nil
            searchTextField?.text = searchText
            tweets.removeAll()
            tableView.reloadData()
            if searchText != nil {
                RecentSearches().add(searchText!)
            }
            refresh()
        }
    }
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1 {
            tableView.estimatedRowHeight = tableView.rowHeight
            tableView.rowHeight = UITableViewAutomaticDimension
        }
        refresh()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func refresh() {
       
        
        if refreshControl != nil {
            refreshControl?.beginRefreshing()
        }
        refresh(refreshControl)
    }
    
    @IBAction func refresh(sender: UIRefreshControl?) {
        if searchText != nil {
            if let request = nextRequestToAttempt {
                request.fetchTweets { (newTweets) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if newTweets.count > 0 {
                            self.tweets.insert(newTweets, atIndex: 0)
                            self.tableView.reloadData()
                            self.tableView.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(0, self.tableView.numberOfSections())), withRowAnimation: .None)
                            self.title = self.searchText
                            sender?.endRefreshing()
                        }
                    })
                }
            }
        } else {
            sender?.endRefreshing()
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchTextField {
            textField.resignFirstResponder()
            searchText = textField.text
        }
        return true
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tweets.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }
    
    //Struct to store constants
    private struct Storyboard {
        static let CellReuseIdentifier = "Tweet"
        static let DetailsIdentifier = "showTweetDetail"
        static let TweetImagesSegue = "showTweetImages"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as TweetTableViewCell
        
        cell.tweet = tweets[indexPath.section][indexPath.row]
        
        return cell
    }
    
    //Prevent segue when there are no details to show
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == Storyboard.DetailsIdentifier {
            if let tweetCell = sender as? TweetTableViewCell {
                if tweetCell.tweet!.hashtags.count + tweetCell.tweet!.urls.count + tweetCell.tweet!.userMentions.count + tweetCell.tweet!.media.count == 0 {
                    return false
                }
            }
        }
        return true
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == Storyboard.DetailsIdentifier {
                if let tdvc = segue.destinationViewController as? TweetDetailTableViewController {
                    if let tweetCell = sender as? TweetTableViewCell {
                        tdvc.tweet = tweetCell.tweet
                    }
                }
            } 
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        
        var favoriteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Save" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
              SavedTweets().add(self.tweets[indexPath.section][indexPath.row])
              tableView.setEditing(false, animated: true)
        })
        favoriteAction.backgroundColor = uicolorFromHex(0xFFD700)
        return [favoriteAction]
    }
    
    
    
    
    //Allows unwind to go back to the root. Prevents intermiediate viewcontrollers form intercepting the rewind
    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        if let first = navigationController?.viewControllers.first as? TweetTableViewController {
            if first == self {
                return true
            }
        }
        return false
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}
