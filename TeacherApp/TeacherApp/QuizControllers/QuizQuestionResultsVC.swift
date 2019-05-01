//
//  QuestionResultsVC.swift
//  TeacherApp
//
//  Created by Ellis Saupe on 4/29/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import UIKit

class QuizQuestionResultsVC: UIViewController {

    var question: Question!
    var questionIndex: Int!
    var answers = [[QuestionAnswer]]()
    var answerTable : QuizAnswerTableVC!
    
    
    @IBOutlet weak var TitleLabel: UILabel!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let id = segue.identifier
        {
            switch (id)
            {
            case "QuestionAnswerTable":
                answerTable = segue.destination as! QuizAnswerTableVC
            default: break
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(answerReceived(_:)), name: .answerSubmitted, object: nil)
        
        TitleLabel.text = question.name
        TitleLabel.sizeToFit()
        
        answerTable.answers = answers
        answerTable.correctAnswer = question.answers.firstIndex(where: {$0.isCorrect}) ?? -1
        answerTable.question = question
        answerTable.tableView.reloadData()
    }
    
    @objc
    func answerReceived(_ notification:Notification)
    {
        if let dict = notification.userInfo as? [String : StudentAnswer], let answer = dict[NotificationUserData.answersReceived.rawValue], answer.answers.count > questionIndex
        {
            let newAnswer = QuestionAnswer(name: answer.displayName, answerIndex: answer.answers[questionIndex])
            answers[newAnswer.answerIndex].append(newAnswer)
            answers[newAnswer.answerIndex].sort(by: {$0.name > $1.name})
            answerTable.answers = answers
            answerTable.tableView.reloadData()
        }
    }
    
    /*func insertSortedAnswer(answer: QuestionAnswer)
    {
        for i in answer.answerIndex ... 0
        {
            if let index = answers.lastIndex(where: {$0.answerIndex == i})
            {
                answers.insert(answer, at: index)
                return
            }
        }
        answers.insert(answer, at: 0)
    }*/
}
