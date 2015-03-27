//
//  RecentsTableViewController.swift
//  twitterHash
//
//  Created by Zackery leman on 3/20/15.
//  Copyright (c) 2015 Zleman. All rights reserved.
//

import UIKit

class RecentsTableViewController: UITableViewController {
    
@IBAction func unwindToRoot(sender: UIStoryboardSegue) { }
    
    @IBAction func clearAll(sender: UIBarButtonItem) {
        
        RecentSearches().removeAll()
        tableView.reloadData()
    }
    
    
    private struct Storyboard {
        static let CellReuseIdentifier = "pastSearchCell"
        static let SegueToSearch = "searchRecent"
    }
    
        // MARK: - VC Life Cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return RecentSearches().values.count
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            RecentSearches().removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = RecentSearches().values[indexPath.row]
        let test = RecentSearches().valuesCount
        cell.detailTextLabel?.text = "\(RecentSearches().valuesCount[indexPath.row])"
        return cell
    }

    
         // MARK: - Segue Handling
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == Storyboard.SegueToSearch {
                if let ttvc = segue.destinationViewController as? TweetTableViewController {
                    if let cell = sender as? UITableViewCell {
                        ttvc.searchText = cell.textLabel?.text
                    }
                }
            }
        }
    }
 
}
