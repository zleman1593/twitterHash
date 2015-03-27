//
//  TweetDetailTableViewController.swift
//  twitterHash
//
//  Created by Zackery leman on 3/16/15.
//  Copyright (c) 2015 Zleman. All rights reserved.
//

import UIKit

class TweetDetailTableViewController: UITableViewController {
    
    var details: [Details] = []
    
    //Struct to hold constants for the story board
    private struct Storyboard {
        static let KeywordCellReuseIdentifier = "keywords"
        static let ImageCellReuseIdentifier = "images"
        static let KeywordSegueIdentifier = "searchSelectedKeyword"
        static let ImageSegueIdentifier = "showImage"
        static let WebSegueIdentifier = "showURL"
        
    }
    
    
    // This represents a scetion on the tableview and contains
    //the detailed information needed to display each section
    struct Details: Printable {
        var title: String
        var data:[DetailItem]
        var description: String { return "\(title): \(data)" }
    }
    
    //Enum for the different possible details
    enum DetailItem: Printable {
        case Keyword(String)
        case Image(NSURL, Double)
        var description: String {
            switch self  {
            case .Keyword(let keyword): return keyword
            case .Image(let url, _): return url.path!
            }
        }
    }
    
    
    //Once tweet is set upon segue add all tweet details into the array of sections
    var tweet: Tweet? {
        didSet{
            title = tweet?.user.screenName
     
                details.append(Details(title: "Tweet", data:  [DetailItem.Keyword(tweet!.text)]))
            
            if let media = tweet?.media {
                if media.count > 0{
                    details.append(Details(title: "Images", data: media.map { DetailItem.Image($0.url, $0.aspectRatio)}))
                }
            }
            if let urls = tweet?.urls {
                if urls.count > 0{
                    
                    details.append(Details(title: "URLs", data: urls.map { DetailItem.Keyword($0.keyword)}))
                }
            }
            
            if let hashtags = tweet?.hashtags {
                if hashtags.count > 0{
                    
                    details.append(Details(title: "Hashtags", data: hashtags.map { DetailItem.Keyword($0.keyword)}))
                }
            }
            if let users = tweet?.userMentions {
                
                var userItems = [DetailItem.Keyword("@" + tweet!.user.screenName)]
                userItems += users.map { DetailItem.Keyword($0.keyword)}
                details.append(Details(title: "Users", data: userItems))
                
            }
        }
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return details.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details[section].data.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let detail = details[indexPath.section].data[indexPath.row]
        switch detail {
        case .Keyword(let keyword):
            let cell = tableView.dequeueReusableCellWithIdentifier(
                Storyboard.KeywordCellReuseIdentifier, forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = keyword
            return cell
        case .Image(let url, let ratio):
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ImageCellReuseIdentifier,
                forIndexPath: indexPath) as ImageCell
            cell.imageUrl = url
            return cell
        }
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let detail = details[indexPath.section].data[indexPath.row]
        switch detail {
        case .Image(_, let ratio):
            //Use aspect ratio to set cell height
            return tableView.bounds.size.width / CGFloat(ratio)
        default:
            //Automatically set cell height
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return details[section].title
    }
    
    //Open the  a link in safari when clicked instead of treating it as a keywor to search
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == Storyboard.KeywordSegueIdentifier {
            if let cell = sender as? UITableViewCell {
                if let url = cell.textLabel?.text {
                    if url.hasPrefix("http") {
                        performSegueWithIdentifier(Storyboard.WebSegueIdentifier, sender: sender)
                        return false
                    }
                }
            }
        }
        return true
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Segues to a new search using the selected keyword. Does not rewind, so the user can just go back and continue with the original search.
        if let identifier = segue.identifier {
            if identifier == Storyboard.KeywordSegueIdentifier {
                if let ttvc = segue.destinationViewController as? TweetTableViewController {
                    if let cell = sender as? UITableViewCell {
                        ttvc.searchText = cell.textLabel?.text
                    }
                }
            }
                // Segues to the attached image and allows user to zoom and pan around image
            else if   identifier == Storyboard.ImageSegueIdentifier {
                if let ivc = segue.destinationViewController as? ImageViewController {
                    if let cell = sender as? ImageCell {
                        ivc.title = title
                        //Pass along the image data, so another network request is unnecessary
                        ivc.imageData = cell.imageData
                    }
                }
            }
            else if identifier == Storyboard.WebSegueIdentifier {
                var destination = segue.destinationViewController as? UIViewController
                if let nc = destination as? UINavigationController {
                    destination = nc.visibleViewController
                    
                    if let wvc = destination as? WebViewController {
                        if let cell = sender as? UITableViewCell {
                            if let url = cell.textLabel?.text {
                                wvc.url = NSURL(string: url)
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    
}


