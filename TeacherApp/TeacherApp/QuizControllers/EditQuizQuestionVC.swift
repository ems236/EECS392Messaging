//
//  EditQuestionVC.swift
//  TeacherApp
//
//  Created by Ellis Saupe on 4/29/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import UIKit

class EditQuizQuestionVC: UIViewController {

    var question: Question?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let id = segue.identifier{
            switch (id)
            {
            case "":
                print("ayy lmao")
            default: break
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        QuestionText.text = question?.name
        AText.text = question?.getAnswer(0)?.text
        BText.text = question?.getAnswer(1)?.text
        CText.text = question?.getAnswer(2)?.text
        DText.text = question?.getAnswer(3)?.text
        
        //Select Picker answer
        AnswerPicker.text = question?.answers.first(where: {$0.isCorrect})?.text
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func SaveClick(_ sender: Any) {
    }
    @IBAction func DeleteClick(_ sender: Any) {
    }
    
    @IBOutlet weak var AText: UITextField!
    @IBOutlet weak var BText: UITextField!
    @IBOutlet weak var CText: UITextField!
    @IBOutlet weak var DText: UITextField!
    
    @IBOutlet weak var QuestionText: UITextField!
    
    @IBOutlet weak var AnswerPicker: UITextField!
    
    @IBAction func ClearA(_ sender: Any) {
    }
    
    @IBAction func ClearB(_ sender: Any) {
    }
    
    @IBAction func ClearC(_ sender: Any) {
    }
    
    
    @IBAction func ClearD(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
