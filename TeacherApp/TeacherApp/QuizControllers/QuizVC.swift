//
//  QuizVC.swift
//  TeacherApp
//
//  Created by Ellis Saupe on 4/29/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import UIKit

class QuizVC: UIViewController, ChildTableSelectDelegate {
    
    var quiz = Quiz.emptyQuiz()
    //var results = [Answer]()
    var questionTable : QuizQuestionsTableVC!
    var quizPosted = false
    var selectedIndex = -1
    
    //Create a segue for the save btn
    @IBAction func deleteQuizQuestion(segue:UIStoryboardSegue) {}
    @IBAction func saveQuizQuestion(segue:UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let id = segue.identifier{
            switch (id)
            {
            case "ChildQuizTable":
                questionTable = segue.destination as! QuizQuestionsTableVC
                //print("Found embedded")
            case "QuizQuestionEdit":
                let QuestionEditVC = segue.destination as! EditQuizQuestionVC
                QuestionEditVC.question = sender as? Question
            case "QuizQuestionAnswers":
                let QuestionResultsVC = segue.destination as! QuizQuestionResultsVC
                QuestionResultsVC.question = sender as! Question
                //QuestionResultsVC.answers =
            default: break
            }
        }
    }
    
    func deleteSelectedQuestion()
    {
        quiz.questions.remove(at: selectedIndex)
        questionTable.tableView.reloadData()
    }
    
    func addQuestion(_ question: Question)
    {
        quiz.questions.append(question)
        questionTable.tableView.reloadData()
    }
    
    func editQuestion(_ new: Question)
    {
        quiz.questions[selectedIndex] = new
        questionTable.tableView.reloadData()
    }
    
    @objc
    func answerReceived(_ notification:Notification)
    {
        if quizPosted, let dict = notification.userInfo as? [String : Answer], let answer = dict["answer"]
        {
            print(answer)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        quiz.questions.append(Question(name: "My new Question"))
        quiz.questions.append(Question(name: "My second Question"))
        // Do any additional setup after loading the view.
        questionTable.parentDelegate = self
        questionTable.quiz = quiz
        questionTable.tableView.reloadData()
        //print("loaded data")
        //print(questionTable.quiz)
        
        NotificationCenter.default.addObserver(self, selector: #selector(answerReceived(_:)), name: .answerSubmitted, object: nil)
    }
    
    func selectedRow(data: Any, index: Int)
    {
        selectedIndex = index
        let identifier = quizPosted ? "QuizQuestionAnswers" : "QuizQuestionEdit"
        self.performSegue(withIdentifier: identifier, sender: data)
    }

    @IBAction func NewQuestion(_ sender: Any)
    {
        self.performSegue(withIdentifier: "QuizQuestionEdit", sender: nil)
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
