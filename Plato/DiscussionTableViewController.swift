//
//  ThreadTableViewController.swift
//  Plato
//
//  Created by Eric Conner on 4/28/15.
//  Copyright (c) 2015 com.platoapp. All rights reserved.
//

import UIKit

class DiscussionTableViewController: UITableViewController {
    
    var discussions: [Discussion] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func viewWillAppear(animated: Bool) {
        if let userId = User.currentUser()?.id {
            PlatoApiService.listDiscussions(userId) { data, error in
                var discs: [Discussion] = []
                for (key, discJson) in data["data"]["discussions"] {
                    var discussion = Discussion.fromJson(discJson)
                    discs.append(discussion)
                }
                self.discussions = discs
                self.tableView.reloadData()
            }
        }
    }
    
    func refresh(sender:AnyObject) {
        // TODO(eric): Actually refresh the table here.
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
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
        return Int(self.discussions.count)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("DiscussionCell", forIndexPath:indexPath) as? DiscussionTableViewCell {
            cell.discussion = self.discussions[indexPath.row]
            return cell
        
        }
        return UITableViewCell()
    }
    
    override func tableView(tv: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tv.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowMessages" {
            if let destination = segue.destinationViewController as? MessagesViewController {
                if let msgIndex = tableView.indexPathForSelectedRow()?.row {
                    destination.discussion = self.discussions[msgIndex]
                }
            }
        }
    }

}
