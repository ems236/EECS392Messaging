//
//  QuizVC.swift
//  TeacherApp
//
//  Created by Ellis Saupe on 4/29/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class QuizVC: UIViewController, ChildTableSelectDelegate {
    
    var quiz = Quiz.emptyQuiz()
    //var results = [Answer]()
    var studentAnswers = [StudentAnswer]()
    var questionTable : QuizQuestionsTableVC!
    var quizPosted = false
    var selectedIndex = -1
    
    let multipeerdriver = MultiPeerDriver.instance
    var quizPeers = [MCPeerID]()
    var totalConnected = 0
    var submitted = 0
    
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
            case "QuizQuestionEdit":
                let QuestionEditVC = segue.destination as! EditQuizQuestionVC
                QuestionEditVC.question = sender as? Question
            case "QuizQuestionAnswers":
                let QuestionResultsVC = segue.destination as! QuizQuestionResultsVC
                QuestionResultsVC.question = sender as! Question
                QuestionResultsVC.answers = makeAnswersArray(questionIndex: selectedIndex)
                QuestionResultsVC.questionIndex = selectedIndex
            default: break
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let testQuestion1 = Question(name: "A question")
        testQuestion1.answers.append(Answer(isCorrect: false, text: "You idiot"))
        testQuestion1.answers.append(Answer(isCorrect: true, text: "Smartboi"))
        
        let testQuestion2 = Question(name: "A question")
        testQuestion2.answers.append(Answer(isCorrect: true, text: "Smartboi"))
        testQuestion2.answers.append(Answer(isCorrect: false, text: "You idiot"))
        testQuestion2.answers.append(Answer(isCorrect: false, text: "You idiot"))
        testQuestion2.answers.append(Answer(isCorrect: false, text: "You idiot"))
        
        quiz.questions.append(testQuestion1)
        quiz.questions.append(testQuestion2)
        
        let answers1 = StudentAnswer(name: "Bobbert", answerIndeces: [1, 3])
        let answers2 = StudentAnswer(name: "Boblin", answerIndeces: [0, 2])
        let answers3 = StudentAnswer(name: "alan", answerIndeces: [1, 0])
        
        studentAnswers = [answers1, answers2, answers3]
        
        ControlsView.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        TitleText.delegate = self
        
        
        questionTable.parentDelegate = self
        questionTable.quiz = quiz
        questionTable.tableView.reloadData()
        
        ActionButton.setTitle("Post Quiz", for: .normal)
        updateLabel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(answerReceived(_:)), name: .answerSubmitted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(newPeer(_:)), name: .studentJoined, object: nil)
    }
    
    func deleteSelectedQuestion()
    {
        quiz.questions.remove(at: selectedIndex)
        questionTable.quiz = quiz
        questionTable.tableView.reloadData()
    }
    
    func addQuestion(_ question: Question)
    {
        quiz.questions.append(question)
        questionTable.quiz = quiz
        questionTable.tableView.reloadData()
    }
    
    func editQuestion(_ new: Question)
    {
        quiz.questions[selectedIndex] = new
        questionTable.quiz = quiz
        questionTable.tableView.reloadData()
    }
    
    @objc
    func answerReceived(_ notification:Notification)
    {
        if quizPosted, let dict = notification.userInfo as? [String : StudentAnswer], let answer = dict[NotificationUserData.answersReceived.rawValue]
        {
            DispatchQueue.main.async
            {
                self.studentAnswers.append(answer)
                self.submitted = self.submitted + 1
                self.updateLabel()
            }
            
        }
    }
    
    @objc
    func newPeer(_ notification: Notification)
    {
        if quizPosted, let dict = notification.userInfo as? [String : MCPeerID], let peer = dict[NotificationUserData.peerChange.rawValue], quizPeers.contains(peer)
        {
            DispatchQueue.main.async
            {
                self.quizPeers.append(peer)
                self.totalConnected = self.quizPeers.count
                self.updateLabel()
            }
        }
    }
    
    func selectedRow(data: Any, index: Int)
    {
        selectedIndex = index
        let identifier = quizPosted ? "QuizQuestionAnswers" : "QuizQuestionEdit"
        self.performSegue(withIdentifier: identifier, sender: data)
    }

    func makeAnswersArray(questionIndex: Int) -> [[QuestionAnswer]]
    {
        var sortedanswers = [[QuestionAnswer]]()
        let answers = studentAnswers.map({QuestionAnswer(name: $0.displayName, answerIndex: $0.answers[questionIndex])})
        
        for _ in 0 ..< quiz.questions[questionIndex].answers.count
        {
            sortedanswers.append([QuestionAnswer]())
        }
        
        for answer in answers
        {
            sortedanswers[answer.answerIndex].append(answer)
        }
        
        for i in 0 ..< sortedanswers.count
        {
            sortedanswers[i].sort(by: {$0.name > $1.name})
        }
        
        return sortedanswers
    }
    
    func updateLabel()
    {
        StatusLabel.text = String(submitted) + " / " + String(totalConnected) + " Submitted"
    }
    
    func postQuiz()
    {
        ActionButton.setTitle("Reset Quiz", for: .normal)
        self.navigationItem.rightBarButtonItem = nil
        submitted = 0
        quizPeers = multipeerdriver.getConnectedPeers()
        totalConnected = quizPeers.count
        TitleText.isEnabled = false
        
        
        if let title = TitleText.text, title != ""
        {
            quiz.title = title
        }
        else
        {
            quiz.title = "New Quiz"
        }
        
        //Reset quiz on error
        if !multipeerdriver.postQuiz(quiz)
        {
            resetQuiz()
        }
    }
    
    func resetQuiz()
    {
        ActionButton.setTitle("Post Quiz", for: .normal)
        self.navigationItem.rightBarButtonItem = AddButton
        submitted = 0
        quizPeers = [MCPeerID]()
        totalConnected = 0
        
        multipeerdriver.resetQuiz()
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
            postQuiz()
        }
        else
        {
            resetQuiz()
        }
        
        updateLabel()
    }
    @IBOutlet weak var StatusLabel: UILabel!
    @IBOutlet weak var TitleText: UITextField!
    @IBOutlet weak var ControlsView: UIView!
}

extension QuizVC: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
}
