//
//  MessagesViewController.swift
//  Plato
//
//  Created by Eric Conner on 5/19/15.
//  Copyright (c) 2015 com.platoapp. All rights reserved.
//

import UIKit
import Socket_IO_Client_Swift

class MessagesViewController: JSQMessagesViewController {
    
    var discussion: Discussion!
    var messages = [Message]()
    var outgoingBubbleImageData: JSQMessagesBubbleImage!
    var incomingBubbleImageData: JSQMessagesBubbleImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.senderId = "+13033507959"
        self.senderDisplayName = "Eric Conner"
        
        PlatoApiService.getMessages(self.discussion.id) { data, error in
            if let fetchedMessages = data["data"]["messages"].array {
                for msgJson in fetchedMessages {
                    var message = Message.fromJson(msgJson)
                    self.messages.append(message)
                }
                self.collectionView.reloadData()
            }
        }
        
        let socket = SocketIOClient(socketURL: "http://localhost:8080")
        socket.on("connect") {data, ack in
            println("socket connected")
            println(data)
        }
        socket.connect()
        
        
        var bubbleFactory = JSQMessagesBubbleImageFactory()
        
        self.outgoingBubbleImageData = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.grayColor());
        self.incomingBubbleImageData = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.greenColor());
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // ACTIONS
    
    func receivedMessagePressed(sender: UIBarButtonItem) {
        println("RECEIVE MESSAGE")
    }
    
    func sendMessage(text: String!) {
        var user = User.currentUser()
        var message = Message()
        message.user = user
        message.text_ = text
        message.discussion = self.discussion
        self.messages.append(message)
        
        PlatoApiService.createMessage(message) { data, error in
            // TODO
        }
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        sendMessage(text)
        
        self.finishSendingMessage()
    }

    override func didPressAccessoryButton(sender: UIButton!) {
        println("Camera pressed!")
    }
    
    // COLLECTION VIEW
    
    // collectionView:messageBubbleImageDataForItemAtIndexPath
    // -------------------------------------------------------
    // Return bubble image data for the message at indexPath.  If the message
    // is sent by the current user then it is outgoing, otherwise it is incoming.
    //
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        let message = self.messages[indexPath.item]
    
        if (message.senderId() == self.senderId) {
            return self.outgoingBubbleImageData
        }
    
        return self.incomingBubbleImageData
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        if message.senderId() == self.senderId {
            cell.textView.textColor = UIColor.blackColor()
        } else {
            cell.textView.textColor = UIColor.whiteColor()
        }
        
        let attributes : [NSObject:AnyObject] = [NSForegroundColorAttributeName:cell.textView.textColor, NSUnderlineStyleAttributeName: 1]
        cell.textView.linkTextAttributes = attributes
        
        //        cell.textView.linkTextAttributes = [NSForegroundColorAttributeName: cell.textView.textColor,
        //            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle]
        return cell
    }
    
    
    // View  usernames above bubbles
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item];
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderId() == message.senderId() {
                return nil;
            }
        }
        
        return NSAttributedString(string:message.senderDisplayName())
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = messages[indexPath.item]
                
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1]
            if previousMessage.senderId() == message.senderId() {
                return CGFloat(0.0);
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }

}
