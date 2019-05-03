//
//  QuizQuestionPage.swift
//  StudentApp
//
//  Created by Ellis Saupe on 5/2/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import UIKit

class QuizQuestionPage: UIViewController
{
    var question: Question!
    var questionIndex: Int!
    var pageController: QuizPageController!
    
    var answerPicker = UIPickerView()
    @IBOutlet weak var QuestionTitle: UILabel!
    @IBOutlet weak var AnswerPickerField: UITextField!
    @IBOutlet weak var AText: UILabel!
    @IBOutlet weak var BText: UILabel!
    @IBOutlet weak var CText: UILabel!
    @IBOutlet weak var DText: UILabel!
    
    let letters = ["A", "B", "C", "D"]
    var answerFields = [UILabel]()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        QuestionTitle.text = question.name
        answerFields = [AText, BText, CText, DText]
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        AnswerPickerField.inputView = answerPicker
        answerPicker.delegate = self
        answerPicker.dataSource = self
        
        hideExtraAnswers()
        setAnswerText()
        // Do any additional setup after loading the view.
    }
    
    func hideExtraAnswers()
    {
        for i in question.answers.count - 1 ..< answerFields.count
        {
            answerFields[i].isHidden = true
        }
    }
    
    func setAnswerText()
    {
        for i in 0 ..< question.answers.count
        {
            answerFields[i].text = question.answers[i].text
        }
    }
}

extension QuizQuestionPage: UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return question.answers.count
    }
}

extension QuizQuestionPage: UIPickerViewDelegate
{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        pageController.setAnswer(row, atIndex: questionIndex)
        AnswerPickerField.text = letters[row]
        self.view.endEditing(true)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return letters[row]
    }
}
