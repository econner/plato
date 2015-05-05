//
//  CreateDiscussionViewController.swift
//  Plato
//
//  Created by Eric Conner on 4/30/15.
//  Copyright (c) 2015 com.platoapp. All rights reserved.
//

import UIKit

class CreateDiscussionViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var toField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.performSegueWithIdentifier("ShowContacts", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "ShowContacts" {
            if let controller = segue.destinationViewController as? UIViewController {
                //self.title = "Cancel"
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
                self.toField.resignFirstResponder()
            }
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
