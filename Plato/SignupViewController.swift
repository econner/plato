//
//  SignupViewController.swift
//  Plato
//
//  Created by Eric Conner on 5/15/15.
//  Copyright (c) 2015 com.platoapp. All rights reserved.
//

import UIKit
import RealmSwift
import AddressBook

class SignupViewController: UITableViewController {
    let realm = Realm()
    
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var phoneExtension: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var textFields: [UITextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.signupButton.enabled = false
        
        self.textFields = [phoneExtension, phoneNumber, firstName, lastName, password]
        for textField in textFields {
            NSNotificationCenter.defaultCenter().addObserver(self, selector:"textFieldChanged:",
                name:UITextFieldTextDidChangeNotification,
                object:textField);
        }
    }
    
    func showError(msg: String) {
        var tc = ToastConfig.sharedInstance()
        Toast.makeToast(msg).show()
    }
    
    func textFieldChanged(notif: NSNotification) {
        var enableButton = true
        for textField in self.textFields {
            if count(textField.text) == 0 {
                enableButton = false
            }
        }
        
        if enableButton {
            self.signupButton.enabled = true
            self.signupButton.alpha = 1
        } else {
            self.signupButton.enabled = false
            self.signupButton.alpha = 0.5
        }
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
        println("SignupViewController.startSignup")
        self.showLoadingIndicator()
        let params = [
            "phone": self.phoneExtension.text + self.phoneNumber.text,
            "first_name": self.firstName.text,
            "last_name": self.lastName.text,
            "password": self.password.text,
        ]
        PlatoApiService.join(params) { data, error in
            self.hideLoadingIndicator()
            
            if error == nil && data["status"] == "success" {
                
                let user = User.fromJson(data["data"])

                self.realm.write {
                    self.realm.add(user)
                }

                User.setCurrentUser(user.id)
                
                var granted = self.determineAddressBookStatus()
                if granted {
                    var phoneNumbers = self.getContactPhoneNumbers()
                    PlatoApiService.addContacts(user.id, phoneNumbers: phoneNumbers) { data, error in
                        // TODO(eric)
                        println(data)
                        println(error)
                    }
                }
                
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
    
    var adbk : ABAddressBook!
    
    func createAddressBook() -> Bool {
        if self.adbk != nil {
            return true
        }
        var err : Unmanaged<CFError>? = nil
        let adbk : ABAddressBook? = ABAddressBookCreateWithOptions(nil, &err).takeRetainedValue()
        if adbk == nil {
            println(err)
            self.adbk = nil
            return false
        }
        self.adbk = adbk
        return true
    }
    
    func determineAddressBookStatus() -> Bool {
        let status = ABAddressBookGetAuthorizationStatus()
        switch status {
        case .Authorized:
            return self.createAddressBook()
        case .NotDetermined:
            var ok = false
            ABAddressBookRequestAccessWithCompletion(nil) {
                (granted:Bool, err:CFError!) in
                dispatch_async(dispatch_get_main_queue()) {
                    if granted {
                        ok = self.createAddressBook()
                    }
                }
            }
            if ok == true {
                return true
            }
            self.adbk = nil
            return false
        case .Restricted:
            self.adbk = nil
            return false
        case .Denied:
            self.adbk = nil
            return false
        }
    }
    
    func getContactPhoneNumbers() -> [String] {
        if !self.determineAddressBookStatus() {
            println("not authorized")
            return []
        }
        let people = ABAddressBookCopyArrayOfAllPeople(adbk).takeRetainedValue() as NSArray as [ABRecord]
        var allPhoneNumbers: [String] = []
        for person in people {
            println(ABRecordCopyCompositeName(person).takeRetainedValue())
            
            let phoneNumbersProperty: ABMultiValueRef = ABRecordCopyValue(person, kABPersonPhoneProperty).takeRetainedValue()
            let phoneNumbers = ABMultiValueCopyArrayOfAllValues(phoneNumbersProperty).takeRetainedValue() as NSArray as! [String]
            allPhoneNumbers.extend(phoneNumbers)
        }
        return allPhoneNumbers
    }

}
