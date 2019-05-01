//
//  EditQuestionVC.swift
//  TeacherApp
//
//  Created by Ellis Saupe on 4/29/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import UIKit

class EditQuizQuestionVC: UIViewController
{

    var question: Question?
    var answersFields = [UITextField?]()
    var answerPicker = UIPickerView()
    var selectedAnswer = -1
    var fieldToValue : [UITextField : Int]!
    var letters = ["A", "B", "C", "D"]
    
    @IBAction func SaveClick(_ sender: Any)
    {
        performSegue(withIdentifier: "QuizQuestionSave", sender: nil)
    }
    
    @IBAction func DeleteClick(_ sender: Any)
    {
        performSegue(withIdentifier: "QuizQuestionDelete", sender: nil)
    }
    
    @IBOutlet weak var AText: UITextField!
    @IBOutlet weak var BText: UITextField!
    @IBOutlet weak var CText: UITextField!
    @IBOutlet weak var DText: UITextField!
    
    
    @IBOutlet weak var QuestionText: UITextField!
    
    @IBOutlet weak var AnswerPickerField: UITextField!
    
    @IBAction func ClearA(_ sender: Any)
    {
        AText.text = ""
    }
    
    @IBAction func ClearB(_ sender: Any)
    {
        BText.text = ""
    }
    
    @IBAction func ClearC(_ sender: Any)
    {
        CText.text = ""
    }
    
    @IBAction func ClearD(_ sender: Any)
    {
        DText.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let id = segue.identifier{
            switch (id)
            {
            case "QuizQuestionSave":
                let quizController = segue.destination as! QuizVC
                if let newQuestion = buildQuestionInForm()
                {
                    print(newQuestion.name)
                    if let _ = question
                    {
                        quizController.editQuestion(newQuestion)
                    }
                    else
                    {
                        quizController.addQuestion(newQuestion)
                    }
                }
            case "QuizQuestionDelete":
                if let _ = question
                {
                    let quizController = segue.destination as! QuizVC
                    quizController.deleteSelectedQuestion()
                }
            default: break
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        QuestionText.text = question?.name
        AText.text = question?.getAnswer(0)?.text
        BText.text = question?.getAnswer(1)?.text
        CText.text = question?.getAnswer(2)?.text
        DText.text = question?.getAnswer(3)?.text
        
        QuestionText.delegate = self
        AText.delegate = self
        BText.delegate = self
        CText.delegate = self
        DText.delegate = self
        
        //Select Picker answer
        if let answer = question?.answers.firstIndex(where: {$0.isCorrect})
        {
            //When coming in, all are fields are nonempty if answer exists
            answerPicker.selectRow(answer, inComponent: 0, animated: false)
            AnswerPickerField.text = letters[answer]
        }
        
        
        answersFields = [AText, BText, CText, DText]
        fieldToValue = [
            AText: 0
            , BText: 1
            , CText: 2
            , DText: 3
        ]
        answerPicker.delegate = self
        AnswerPickerField.inputView = answerPicker
        // Do any additional setup after loading the view.
    }
    
    func getNonEmptyAnswers() -> [UITextField?]
    {
        return answersFields.filter({$0?.text != ""})
    }
    
    func buildQuestionInForm() -> Question?
    {
        let newQuestion = Question(name: "")
        for field in getNonEmptyAnswers()
        {
            var isCorrect = false
            if let num = fieldToValue[field!]
            {
                isCorrect = num == selectedAnswer
            }
            newQuestion.answers.append(Answer(isCorrect: isCorrect, text: (field?.text)!))
        }
        
        if isForminValid()
        {
            print("invalid forms")
            return nil
        }
        newQuestion.name = QuestionText.text!
        if newQuestion.answers.first(where: {$0.isCorrect}) == nil
        {
            newQuestion.answers[0].isCorrect = true
        }
        return newQuestion
    }
    
    func isForminValid() -> Bool
    {
        return getNonEmptyAnswers().count == 0 || QuestionText.text == nil
    }
    
    
    func getLetterFromSelectedRow(row: Int) -> String
    {
        return letters[fieldToValue[getNonEmptyAnswers()[row]!]!]
    }
}

extension EditQuizQuestionVC: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField.resignFirstResponder()  //if desired
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
}

extension EditQuizQuestionVC: UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return getNonEmptyAnswers().count
    }
}

extension EditQuizQuestionVC: UIPickerViewDelegate
{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedAnswer = fieldToValue[getNonEmptyAnswers()[row]!]!
        AnswerPickerField.text = getLetterFromSelectedRow(row: row)
        self.view.endEditing(true)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return getLetterFromSelectedRow(row: row)
    }
}
