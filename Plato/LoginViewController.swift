//
//  LoginViewController.swift
//  Plato
//
//  Created by Eric Conner on 5/18/15.
//  Copyright (c) 2015 com.platoapp. All rights reserved.
//

import UIKit
import RealmSwift

class LoginViewController: UITableViewController {
    
    let realm = Realm()

    @IBOutlet weak var phoneExtension: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
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
    
    func showError(msg: String) {
        var tc = ToastConfig.sharedInstance()
        Toast.makeToast(msg).show()
    }
    
    @IBAction func startLogin(sender: UIButton) {
        self.showLoadingIndicator()
        let params = [
            "phone": self.phoneExtension.text + self.phoneNumber.text,
            "password": self.password.text,
        ]
        println("LoginViewController.startLogin")
        
        PlatoApiService.login(params) { data, error in
            self.hideLoadingIndicator()
            
            if error == nil && data["status"].string! == "success" {
                let user = User.fromJson(data["data"])
                
                self.realm.write {
                    self.realm.add(user, update: true)
                }
                
                User.setCurrentUser(user.id)
                
                self.dismissViewControllerAnimated(false, completion: nil)
            } else {
                if let message = data["message"].string {
                    self.showError(message)
                } else {
                    if let errorMsg = error?.description {
                        self.showError(errorMsg)
                    }
                }
            }
        }
    }

}
