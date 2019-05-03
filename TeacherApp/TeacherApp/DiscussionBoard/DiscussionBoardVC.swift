//
//  DiscussionBoardVC.swift
//  TeacherApp
//
//  Created by Ellis Saupe on 5/1/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class DiscussionBoardVC: UIViewController {

    var messageTable: DiscussionMessagesTableVC!
    var messages = [DiscussionPost]()
    
    var hasChanged = false
    var initialConstant : CGFloat = 0
    let multipeerdriver = MultiPeerDriver.instance
    let defaultMessage = "Message here"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let id = segue.identifier{
            switch (id)
            {
            case "ChildMessageTable":
                messageTable = (segue.destination as! DiscussionMessagesTableVC)
            default: break
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(receivedNewMessage(_:)), name: .messageReceived, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sendOldData(_:)), name: .studentJoined, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
        
        MessageText.delegate = self
        MessageText.keyboardType = .default
        MessageText.isUserInteractionEnabled = true
        
        initialConstant = ControlBottom.constant
        
        /*
        let message1 = DiscussionPost(text: "Whoah boy here comes a long one This might have 2 maybe even 3 line breaks it's insane come on man give me extra credit for all this typing", sender: "Boblin")
        message1.isTeacher = false
        
        let message2 = DiscussionPost(text: "A quickie", sender: "Geoff")
        message2.isTeacher = false
        
        let message3 = DiscussionPost(text: "A shorter message but it's from the teaacher so that's cool", sender: "Ayy Lmao")
        
        messages = [message1, message2, message3]
        */
        messageTable.loadMessages(messages)
    }
    
    @objc
    func receivedNewMessage(_ notification: Notification)
    {
        if let dict = notification.userInfo as? [String : DiscussionPost], let message = dict[NotificationUserData.messageReceived.rawValue]
        {
            DispatchQueue.main.async
            {
                self.addMessage(message)
            }
        }
    }
    
    @objc
    func sendOldData(_ notification: Notification)
    {
        if let dict = notification.userInfo as? [String : MCPeerID], let newUser = dict[NotificationUserData.peerChange.rawValue]
        {
            //Only affects teacher side
            multipeerdriver.deliverOldMessages(messages, to: newUser)
        }
    }
    
    @objc
    func keyboardShow(_ notification: Notification)
    {
        if let info = notification.userInfo, let rect = info[UIWindow.keyboardFrameEndUserInfoKey] as? CGRect
        {
            UIView.animate(withDuration: 0.25, animations:
            {
                self.view.layoutIfNeeded()
                self.ControlBottom.constant = -1 * rect.height
            })
        }
    }
    
    @objc
    func keyboardHide(_ notification: Notification)
    {
        UIView.animate(withDuration: 0.25, animations:
        {
            self.view.layoutIfNeeded()
            self.ControlBottom.constant = self.initialConstant
        })
    }
    
    func addMessage(_ message: DiscussionPost)
    {
        messages.append(message)
        messageTable.loadMessages(messages)
    }
    
    @IBOutlet weak var MessageText: UITextView!
    
    @IBOutlet weak var ControlBottom: NSLayoutConstraint!
    @IBAction func SendBtn(_ sender: Any)
    {
        var displayname = "No name set"
        if let name = UserDefaults.standard.object(forKey: "DisplayName") as? String
        {
            displayname = name
        }
        
        let message = DiscussionPost(text: MessageText.text, sender: displayname)
        MessageText.text = defaultMessage
        hasChanged = false
        MessageText.resignFirstResponder()
        
        //Returns false on failure if we'd like to check for errors
        let _ = multipeerdriver.postDiscussionMessage(message)
        addMessage(message)
    }
}

extension DiscussionBoardVC: UITextViewDelegate
{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if(text == "\n")
        {
            SendBtn(self)
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if !hasChanged
        {
            hasChanged = true
            textView.text = ""
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        return true
    }
}
