//
//  CreateDiscussionViewController.swift
//  Plato
//
//  Created by Eric Conner on 4/30/15.
//  Copyright (c) 2015 com.platoapp. All rights reserved.
//

import UIKit

class CreateDiscussionViewController: UIViewController, UITextFieldDelegate {
    
    var showContactsButton: UIButton!
    var contactPickerView: THContactPickerView!
    var selectedContacts: [Contact] = []
    
    @IBOutlet weak var discussionText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        self.discussionText.backgroundColor = UIColor.grayColor()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        self.contactPickerView = THContactPickerView(frame: CGRectMake(0, 0, self.view.frame.size.width, 100.0))
        self.contactPickerView.setPromptLabelText("To:")
        self.contactPickerView.setPlaceholderLabelText("")
        self.contactPickerView.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin|UIViewAutoresizing.FlexibleWidth
        self.contactPickerView.resignFirstResponder()
        self.view.addSubview(self.contactPickerView)
        
        self.showContactsButton = UIButton(frame: self.contactPickerView.frame)
        self.showContactsButton.addTarget(self, action:"showContacts", forControlEvents:UIControlEvents.TouchUpInside)
        var layer = self.showContactsButton.layer
        layer.backgroundColor = UIColor.clearColor().CGColor
        
        self.view.addSubview(self.showContactsButton)
    }
    
    
    // MARK: - Layout Methods
    func adjustTableFrame() {
        let yOffset = self.contactPickerView.frame.origin.y + self.contactPickerView.frame.size.height
        let tableFrame = CGRectMake(0, yOffset, self.view.frame.size.width, self.view.frame.size.height - yOffset)
        self.discussionText.frame = tableFrame;
    }
    
    override func viewDidLayoutSubviews() {
        self.adjustTableFrame()
    }
    
    // prepareForUnwind
    // ----------------------------
    // Triggered by ChooseContactsViewController when the user has selected
    // contacts for their discussion.
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        if let controller = segue.sourceViewController as? ChooseContactsViewController {
            self.contactPickerView.removeAllContacts()
            self.selectedContacts = controller.privateSelectedContacts
            for contact in self.selectedContacts {
                self.contactPickerView.addContact(contact, withName: contact.name)
            }
            self.showContactsButton.frame = self.contactPickerView.frame
            
            self.contactPickerView.resignFirstResponder()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showContacts() {
        self.performSegueWithIdentifier("ShowContacts", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "ShowContacts" {
            if let controller = segue.destinationViewController as? ChooseContactsViewController {
                controller.privateSelectedContacts = self.selectedContacts
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
            }
        }
    }

}
