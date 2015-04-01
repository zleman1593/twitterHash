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
            animateTable()
    
        
    }
    
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

    func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells()
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: nil, animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
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
