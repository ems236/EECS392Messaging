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
    var answers = [QuestionAnswer]()
    var answerTable : QuizAnswerTableVC!
    
    
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
        
        answers.sort
        {
            return $0.answerIndex < $1.answerIndex
        }
        answerTable.answers = answers
        answerTable.tableView.reloadData()
    }
    
    @objc
    func answerReceived(_ notification:Notification)
    {
        if let dict = notification.userInfo as? [String : StudentAnswer], let answer = dict["answer"], let  _ = answer.answers[questionIndex]
        {
            let newAnswer = QuestionAnswer(name: answer.displayName, answerIndex: answer.answers[questionIndex]!)
            insertSortedAnswer(answer: newAnswer)
            answerTable.answers = answers
            answerTable.tableView.reloadData()
        }
    }
    
    func insertSortedAnswer(answer: QuestionAnswer)
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
