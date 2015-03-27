//
//  FavoriteTableViewController.swift
//  twitterHash
//
//  Created by Zackery leman on 3/20/15.
//  Copyright (c) 2015 Zleman. All rights reserved.
//

import UIKit

class FavoriteTableViewController: UITableViewController {
    
    @IBAction func clearAll(sender: UIBarButtonItem) {
        SavedTweets().removeAll()
        tableView.reloadData()
    }
    
    
    private struct Storyboard {
        static let CellReuseIdentifier = "savedTweet"
    }
    
    
    // MARK: - VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return SavedTweets().tweets.count
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            SavedTweets().removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = SavedTweets().tweets[indexPath.row]
        
        return cell
    }
    
}
