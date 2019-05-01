//
//  DiscussionBoardVC.swift
//  TeacherApp
//
//  Created by Ellis Saupe on 5/1/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import UIKit

class DiscussionBoardVC: UIViewController {

    var messageTable: DiscussionMessagesTableVC!
    var messages = [DiscussionPost]()
    
    let multipeerdriver = MultiPeerDriver.instance
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let id = segue.identifier{
            switch (id)
            {
            case "ChildMessageTable":
                messageTable = segue.destination as! DiscussionMessagesTableVC
            default: break
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(receivedNewMessage(_:)), name: .messageReceived, object: nil)
        // Do any additional setup after loading the view.
        
        MessageText.delegate = self
        MessageText.keyboardType = .default
        MessageText.isUserInteractionEnabled = true
        
        messageTable.loadMessages(messages)
    }
    
    @objc
    func receivedNewMessage(_ notification: Notification)
    {
        if let dict = notification.userInfo as? [String : DiscussionPost], let message = dict[NotificationUserData.messageReceived.rawValue]
        {
            addMessage(message)
        }
    }
    
    func addMessage(_ message: DiscussionPost)
    {
        messages.append(message)
        messageTable.loadMessages(messages)
    }
    
    @IBOutlet weak var MessageText: UITextView!
    
    @IBAction func SendBtn(_ sender: Any)
    {
        let message = DiscussionPost(text: MessageText.text, sender: "PLACEHOLDER TEACHER")
        MessageText.text = ""
        //multipeerdriver.sendDiscussionPost()
        addMessage(message)
    }
}

extension DiscussionBoardVC: UITextViewDelegate
{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        return true
    }
}
