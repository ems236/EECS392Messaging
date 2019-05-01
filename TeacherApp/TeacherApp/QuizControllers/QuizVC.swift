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
    var studentAnswers = [StudentAnswer]()
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
                QuestionResultsVC.answers = studentAnswers.map({QuestionAnswer(name: $0.displayName, answerIndex: $0.answers[selectedIndex] ?? 0)})
                QuestionResultsVC.questionIndex = selectedIndex
            default: break
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        quiz.questions.append(Question(name: "My new Question"))
        quiz.questions.append(Question(name: "My second Question"))
 
        questionTable.parentDelegate = self
        questionTable.quiz = quiz
        questionTable.tableView.reloadData()
        
        ActionButton.setTitle("Post Quiz", for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(answerReceived(_:)), name: .answerSubmitted, object: nil)
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
        if quizPosted, let dict = notification.userInfo as? [String : StudentAnswer], let answer = dict["answer"]
        {
            print(answer)
        }
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
    
    @IBOutlet var AddButton: UIBarButtonItem!
    @IBOutlet weak var ActionButton: UIButton!
    
    @IBAction func ActionButtonClick(_ sender: Any)
    {
        quizPosted = !quizPosted
        if quizPosted
        {
            ActionButton.setTitle("Reset Quiz", for: .normal)
            self.navigationItem.rightBarButtonItem = nil
        }
        else
        {
            ActionButton.setTitle("Post Quiz", for: .normal)
            self.navigationItem.rightBarButtonItem = AddButton
        }
    }
    @IBOutlet weak var StatusLabel: UILabel!
}
