//
//  SecondViewController.swift
//  Plato
//
//  Created by Eric Conner on 4/28/15.
//  Copyright (c) 2015 com.platoapp. All rights reserved.
//

import UIKit

class Contact : Equatable {
    var name = ""
}

func ==(lhs: Contact, rhs: Contact) -> Bool
{
    return lhs.name == rhs.name
}

class SecondViewController: UIViewController, THContactPickerDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var contactPickerView: THContactPickerView!
    @IBOutlet weak var tableView: UITableView!
    
    var contacts: [Contact] = []
    var privateSelectedContacts: [Contact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let names = ["Hari Arul", "Eric Conner", "Isabel Sosa", "Daniel Lynch", "Lily Guo", "Andres Morales"]
        for name in names {
            var contact = Contact()
            contact.name = name
            contacts.append(contact)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK: - UITableView Delegate and Datasource functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell  {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("THContactPickerContactCell", forIndexPath:indexPath) as? UITableViewCell {
            cell.textLabel!.text = self.contacts[indexPath.row].name

            if contains(self.privateSelectedContacts, self.contacts[indexPath.row]) {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }

            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        var contact = self.contacts[indexPath.row]
        var contactTitle = self.contacts[indexPath.row].name

        if contains(self.privateSelectedContacts, contact) {
            cell!.accessoryType = UITableViewCellAccessoryType.None
            if let index = find(self.privateSelectedContacts, contact) {
                self.privateSelectedContacts.removeAtIndex(index)
            }
            self.contactPickerView.removeContact(contact);
        } else {
            // Contact has not been selected, add it to THContactPickerView
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            self.privateSelectedContacts.append(contact)
            self.contactPickerView.addContact(contact, withName:contactTitle);
        }
        
        // TODO: Add back didChangeSelectedItems?
        self.tableView.reloadData()
    }
    
    // MARK - THContactPickerDelegate
    
    func contactPickerTextViewDidChange(textViewText: String) {
        // TODO: Fix when dealing with filteredContacts
//        if textViewText == "" {
//            self.filteredContacts = self.contacts;
//        } else {
//            NSPredicate *predicate = [self newFilteringPredicateWithText:textViewText];
//            self.filteredContacts = [self.contacts filteredArrayUsingPredicate:predicate];
//        }
//        self.tableView.reloadData();
    }
    
    func contactPickerDidResize(contactPickerView: THContactPickerView) {
        var frame = self.tableView.frame;
        frame.origin.y = contactPickerView.frame.size.height + contactPickerView.frame.origin.y;
        self.tableView.frame = frame;
    }
    
    func contactPickerDidRemoveContact(contactObj: AnyObject) {
        let contact = contactObj as! Contact
        if let index = find(self.privateSelectedContacts, contact) {
            self.privateSelectedContacts.removeAtIndex(index)
            var cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow:index, inSection:0))
            cell?.accessoryType = UITableViewCellAccessoryType.None
            
            // self.didChangeSelectedItems()
        }
    }
    
    func contactPickerTextFieldShouldReturn(textField: UITextField) -> Bool {
        // TODO: Not sure if this is needed?
//        if count(textField.text) > 0 {
//            var contactName = textField.text
//            self.privateSelectedContacts.append(contact);
//            self.contactPickerView.addContact(contact, withName:contact);
//        }
        return true
    }
    
    
}

