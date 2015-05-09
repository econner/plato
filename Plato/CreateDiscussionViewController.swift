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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        
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
        
//        var gestureRecognizer = UITapGestureRecognizer(target: self, action: "showContacts")
//        gestureRecognizer.delegate = self
//        self.contactPickerView.addGestureRecognizer(gestureRecognizer)
    }
    
//    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
//        println("TOUCHED VIEW \(touch.view)")
//        if (touch.view.isKindOfClass(UITextField)) {
//            println("IS A TEXT FIELD")
//            return false
//        }
//        return true
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showContacts() {
        self.performSegueWithIdentifier("ShowContacts", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "ShowContacts" {
            if let controller = segue.destinationViewController as? UIViewController {
                //self.title = "Cancel"
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
            }
        }
    }

}
