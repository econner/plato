//
//  SignupViewController.swift
//  Plato
//
//  Created by Eric Conner on 5/15/15.
//  Copyright (c) 2015 com.platoapp. All rights reserved.
//

import UIKit

class SignupViewController: UITableViewController {
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var phoneExtension: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
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
    
    func showLoadingIndicator() {
        dispatch_async(dispatch_get_main_queue()) {
            self.loadingIndicator.startAnimating()
        }
    }
    
    func hideLoadingIndicator() {
        dispatch_async(dispatch_get_main_queue()) {
            self.loadingIndicator.stopAnimating()
        }
    }

    @IBAction func startSignup(sender: UIButton) {
        self.showLoadingIndicator()
        let params = [
            "phone": self.phoneExtension.text + self.phoneNumber.text,
            "first_name": self.firstName.text,
            "last_name": self.lastName.text,
            "password": self.password.text,
        ]
        PlatoApiService.join(params) { data, error in
            if error == nil {
                self.hideLoadingIndicator()
                
                let user = User()
                User.setCurrentUser(data["data", "user_id"].int!)
                self.dismissViewControllerAnimated(false, completion: nil)
            }
        }
    }

}
