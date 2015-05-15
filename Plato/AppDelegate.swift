//
//  AppDelegate.swift
//  Plato
//
//  Created by Eric Conner on 4/28/15.
//  Copyright (c) 2015 com.platoapp. All rights reserved.
//

import Realm
import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let realm = RLMRealm.defaultRealm()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Reset the realm
        realm.beginWriteTransaction()
        realm.deleteAllObjects()
        realm.commitWriteTransaction()

        // Create some users
        let user1 = User()
        user1.first_name = "Joe"
        user1.last_name = "Conner"
        user1.phone = "5556167896"
        
        let user2 = User()
        user2.first_name = "Hari"
        user2.last_name = "Arul"
        user2.phone = "2482073606"
        
        // Add some contacts
        let user3 = User()
        user3.first_name = "Isabel"
        user3.last_name = "Sosa"
        user3.phone = "5555555555"
        
        user1.contacts.addObject(user2)
        user1.contacts.addObject(user3)
        
        user2.contacts.addObject(user1)
        user2.contacts.addObject(user3)
        
        user3.contacts.addObject(user1)
        user3.contacts.addObject(user2)
        
        // Create a discussion
        let discussion = Discussion()
        discussion.image_url = "http://ww2.kqed.org/lowdown/wp-content/uploads/sites/26/2015/04/Yosemite.gif"
        discussion.text = "Where did winter go? Winter pics of Yosemite's half dome since drought hit."
        discussion.user = user1
        discussion.participants.addObject(user2)
        
        let message = Message()
        message.text = "Woah, so crazy. The drought is really bad."
        message.user = user2
        message.discussion = discussion
        discussion.messages.addObject(message)
        
        realm.beginWriteTransaction()
        realm.addObject(user1)
        realm.addObject(user2)
        realm.addObject(user3)
        realm.addObject(discussion)
        realm.addObject(message)
        realm.commitWriteTransaction()
        
        println(User.currentUser())
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Display login controller if not current user logged in.
        if User.currentUser() == nil {
            if var loginController = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("authNavController") as? UIViewController {
                self.window?.rootViewController?.presentViewController(loginController, animated: false, completion: nil)
            }
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

