//
//  QuizVC.swift
//  TeacherApp
//
//  Created by Ellis Saupe on 4/29/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import UIKit

class QuizVC: UIViewController, ChildSegueDelegate {

    var quiz = Quiz.emptyQuiz()
    //var results = [Answer]()
    var questionTable : QuizQuestionsTableVC!
    var quizPosted = false
    
    //Create a segue for the save btn
    @IBAction func deleteQuizQuestion(segue:UIStoryboardSegue) {}
    @IBAction func saveQuizQuestion(segue:UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let id = segue.identifier{
            switch (id)
            {
            case "ChildQuizTable":
                //questionTable = segue.destination as! QuizQuestionsTableVC
                print("Found embedded")
            case "QuizQuestionEdit":
                let QuestionEditVC = segue.destination as! EditQuizQuestionVC
                QuestionEditVC.question = sender as! Question
            case "QuizQuestionAnswers":
                let QuestionResultsVC = segue.destination as! QuizQuestionResultsVC
                QuestionResultsVC.question = sender as! Question
                //QuestionResultsVC.answers =
            default: break
            }
        }
    }
    
    @objc
    func answerReceived(_ notification:Notification)
    {
        if quizPosted, let dict = notification.userInfo as? [String : Answer], let answer = dict["answer"]
        {
            print(answer)
        }
    }
    
    func segueFromChild(identifier: String, sender: Any?)
    {
        self.performSegue(withIdentifier: identifier, sender: sender)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //questionTable.segueDelegate = self
        //questionTable.quiz = quiz
        //questionTable.tableView.reloadData()
        print("loaded data")
        //print(questionTable.quiz)
        
        NotificationCenter.default.addObserver(self, selector: #selector(answerReceived(_:)), name: .answerSubmitted, object: nil)
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
