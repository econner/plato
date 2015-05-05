//
//  ChooseContactsViewController.swift
//  Plato
//
//  Created by Eric Conner on 4/30/15.
//  Copyright (c) 2015 com.platoapp. All rights reserved.
//

import UIKit

class ChooseContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var toField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem?.title = "Cancel"
        self.toField.becomeFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.toField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 5
    }
    
    let names = ["Hari Arul", "Eric Conner", "Isabel Sosa", "Daniel Lynch", "Lily Guo", "Andres Morales"]
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath:indexPath) as? ContactTableViewCell {
            
            cell.nameLabel.text = names[indexPath.row]
            return cell
            
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(toField.text)
        if toField.text != "" {
            toField.text = toField.text + ", " + names[indexPath.row]
        } else {
            toField.text = names[indexPath.row]
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
