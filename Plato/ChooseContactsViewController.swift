//
//  ChooseContactsViewController.swift
//  Plato
//
//  Created by Eric Conner on 4/30/15.
//  Copyright (c) 2015 com.platoapp. All rights reserved.
//

import UIKit
import THContactPicker


class ChooseContactsViewController: UIViewController, THContactPickerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var contacts: [User] = []
    var privateSelectedContacts: [User] = []
    var filteredContacts: [User] = []
    
    var contactPickerView: THContactPickerView!
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("ChooseContactsViewController:viewDidLoad")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "finishSelectingContacts:")
        
        // Do any additional setup after loading the view, typically from a nib.
        self.filteredContacts = contacts
        
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.contactPickerView = THContactPickerView(frame: CGRectMake(0, 0, self.view.frame.size.width, 100.0))
        self.contactPickerView.setPromptLabelText("To:")
        self.contactPickerView.setPlaceholderLabelText("")
        self.contactPickerView.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin|UIViewAutoresizing.FlexibleWidth
        self.contactPickerView.delegate = self
        self.view.addSubview(self.contactPickerView)
        self.contactPickerView.becomeFirstResponder()
        
        let tableFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.contactPickerView.frame.size.height)
        self.tableView = UITableView(frame: tableFrame, style: UITableViewStyle.Plain)
        self.tableView.autoresizingMask = UIViewAutoresizing.FlexibleHeight|UIViewAutoresizing.FlexibleWidth
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.blueColor()
        self.view.insertSubview(self.tableView, belowSubview: self.contactPickerView)
        
        for contact in self.privateSelectedContacts {
            self.contactPickerView.addContact(contact, withName: contact.name)
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    @IBAction func finishSelectingContacts(sender: UIButton) {
        performSegueWithIdentifier("unwindToCreateDiscussion", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK: - Layout Methods
    func adjustTableFrame() {
        let yOffset = self.contactPickerView.frame.origin.y + self.contactPickerView.frame.size.height
        let tableFrame = CGRectMake(0, yOffset, self.view.frame.size.width, self.view.frame.size.height - yOffset)
        self.tableView.frame = tableFrame;
    }
    
    override func viewDidLayoutSubviews() {
        self.adjustTableFrame()
    }
    
    // MARK: - UITableView Delegate and Datasource functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredContacts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell  {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("THContactPickerContactCell") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "THContactPickerContactCell")
        }
        
        cell!.textLabel!.text = self.filteredContacts[indexPath.row].name
        
        if contains(self.privateSelectedContacts, self.filteredContacts[indexPath.row]) {
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell!.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        var contact = self.filteredContacts[indexPath.row]
        var contactTitle = self.filteredContacts[indexPath.row].name
        
        if contains(self.privateSelectedContacts, contact) {
            println("PRIV SELECTED CONTACTS \(contact.name)")
            cell!.accessoryType = UITableViewCellAccessoryType.None
            if let index = find(self.privateSelectedContacts, contact) {
                self.contactPickerView.removeContact(self.privateSelectedContacts[index])
                self.privateSelectedContacts.removeAtIndex(index)
            }
            self.contactPickerView.removeContact(contact)
        } else {
            // Contact has not been selected, add it to THContactPickerView
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            self.privateSelectedContacts.append(contact)
            self.contactPickerView.addContact(contact, withName:contactTitle)
        }
        
        // TODO: Add back didChangeSelectedItems?
        self.filteredContacts = self.contacts
        self.tableView.reloadData()
    }
    
    // MARK - THContactPickerDelegate
    
    func contactPickerTextViewDidChange(textViewText: String) {
        if textViewText == "" {
            self.filteredContacts = self.contacts
        } else {
            let predicate = NSPredicate(format:"self contains[cd] %@", textViewText)
            self.filteredContacts = self.contacts.filter() { predicate.evaluateWithObject($0.name) }
        }
        self.tableView.reloadData();
    }
    
    func contactPickerDidResize(contactPickerView: THContactPickerView) {
        println(self.tableView)
        var frame = self.tableView.frame;
        frame.origin.y = contactPickerView.frame.size.height + contactPickerView.frame.origin.y;
        self.tableView.frame = frame;
    }
    
    func contactPickerDidRemoveContact(contactObj: AnyObject) {
        if let contact = contactObj as? User {
            println("Removed contact: \(contact)")
            if let index = find(self.privateSelectedContacts, contact) {
                self.privateSelectedContacts.removeAtIndex(index)
                var cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow:index, inSection:0))
                cell?.accessoryType = UITableViewCellAccessoryType.None
            }
        }
    }
    
    func contactPickerTextFieldShouldReturn(textField: UITextField) -> Bool {
        println("contactPickerTextFieldShouldReturn")
        if count(textField.text) > 0 {
            var contactName = textField.text
// TODO
//            var contact = User()
//            contact.name = contactName
//            self.privateSelectedContacts.append(contact);
//            self.contactPickerView.addContact(contact, withName:contactName);
        }
        return true
    }
}
