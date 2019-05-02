//
//  SettingsVC.swift
//  StudentApp
//
//  Created by Ellis Saupe on 5/1/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        NameField.keyboardType = .default
        NameField.delegate = self
        
        if let name = UserDefaults.standard.object(forKey: "DisplayName") as? String
        {
            NameField.text = name
        }
        // Do any additional setup after loading the view.
    }
    
    func setDisplayName(_ name: String)
    {
        UserDefaults.standard.set(name, forKey: "DisplayName")
    }
    
    @IBOutlet weak var NameField: UITextField!
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
