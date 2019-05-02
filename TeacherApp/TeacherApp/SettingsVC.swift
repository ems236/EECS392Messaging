//
//  SettingsVC.swift
//  TeacherApp
//
//  Created by Ellis Saupe on 5/1/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController
{

    let driver = MultiPeerDriver.instance
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    //{
    //}
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        setConnectionText()
        
        NameField.keyboardType = .default
        NameField.delegate = self
        
        if let name = UserDefaults.standard.object(forKey: "DisplayName") as? String
        {
            NameField.text = name
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(setConnectionText), name: .studentJoined, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setConnectionText), name: .studentDisconnect, object: nil)
    }
    
    @objc
    func setConnectionText()
    {
        let count = String(driver.getConnectedPeers().count)
        DispatchQueue.main.async
        {
            self.ConnectedStudentsLabel.text = count + " Students Connected"
        }
        
    }
    
    func setDisplayName(_ name: String)
    {
        UserDefaults.standard.set(name, forKey: "DisplayName")
    }
    
    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var ConnectedStudentsLabel: UILabel!
}

extension SettingsVC: UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        setDisplayName(textField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
}
