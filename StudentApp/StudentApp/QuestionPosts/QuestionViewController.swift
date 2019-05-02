//
//  QuestionViewController.swift
//  StudentApp
//
//  Created by Jackson Nelson-Gal on 4/27/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    private weak var model: ConnectionData!
    
    @IBOutlet weak var headerField: UITextField! {
        didSet { headerField.delegate = self }
    }
    @IBOutlet weak var descriptionField: UITextView! {
        didSet { descriptionField.delegate = self }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        model = ConnectionData.instance()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if(text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    @IBAction func submitQuestion(_ sender: UIButton) {
        // check if all inputs are valid.
        // if they aren't, display a popup that says what needs to be fixed.
        // if they are, call the submission method, display a popup that says the question was sent then clear the text.
        let (isValid,message) = isValidSubmission()
        print("isValid: \(isValid)")
        print("message: \(message)")
        if isValid
        {
            model.submitQuestionToTeacher(header: headerField.text!, desc: descriptionField.text!)
        }
        // display popup with message as its text
        displayPopup(title: isValid ? "Success!" : "Can't send message!", message: message, handler: isValid ? clearAllText(_:) : nil)
    }
    
    private func clearAllText(_: UIAlertAction) {
        headerField.text = ""
        descriptionField.text = ""
    }
    
    private func displayPopup(title: String, message: String, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: handler)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func isValidSubmission() -> (isValid: Bool, message: String) {
        
        var checks = [(Bool,String)]()
        
        checks.append(isTextEmptyWithErrorMsg(text: headerField.text, name: "header"))
        checks.append(isTextEmptyWithErrorMsg(text: descriptionField.text, name: "description"))
        
        return formattedIssueMessage(checks: checks, ifValid: "Your question is being sent to the instructor.\n")
    }
    
    private func isTextEmptyWithErrorMsg(text: String?, name: String) -> (isntEmpty: Bool, errorMsg: String) {
        return (text == nil || text!.isEmpty, "There needs to be a \(name).")
    }
    
    private func formattedIssueMessage(checks: [(isInvalid:Bool, errorMsg:String)], ifValid validMsg: String) -> (isValid: Bool, message: String) {
        var result = true
        var msg = ""
        var issueCount = 0
        
        for check in checks {
            if check.isInvalid {
                result = false
                issueCount+=1;
                msg = formattedIssueMessage(message: check.errorMsg, issues: issueCount, current: msg)
            }
        }
        
        if result { msg = validMsg }
        else { msg = "\(issueCount) Issues:\n" + msg}
        return (result, msg)
    }
    
    private func formattedIssueMessage(message: String, issues: Int, current: String) -> String {
        return current + (issues > 1 ? "\n" : "") + "\(issues). " + message
    }
}
