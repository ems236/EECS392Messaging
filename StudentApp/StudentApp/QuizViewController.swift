//
//  QuizViewController.swift
//  StudentApp
//
//  Created by Jackson Nelson-Gal on 4/27/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    
    weak var quiz: Quiz?
    @IBOutlet weak var quizView: UIView!
    private weak var prev_question: Question?
    private weak var curr_question: Question?
    private weak var next_question: Question?
    
    //private weak var contentQuizView: QuizDescriptionContentView!
    private var contentQuizView: QuizContentTemplate!
    //private weak var contentQuestionView: QuestionContentView!
    //@IBOutlet var contentQuizView: UIView!
//    @IBOutlet weak var quizDescription: UITextView! {
//        didSet {
//            quizDescription.clearsOnInsertion = true
//        }
//    }
    
    
    // Content in content view
    @IBOutlet weak var titleCard: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    
    private var radius: CGFloat!
    
    override func viewDidLoad() {
        print("presented!")
        super.viewDidLoad()
        radius = quizView.frame.width/15
        initDisplay()
    }
    
    private func initDisplay() {
        quizView.layer.cornerRadius = radius
        quizView.clipsToBounds = false
        submitButton.layer.cornerRadius = radius
        loadQuizDisplay()
        loadQuestionDisplay()
        loadNextQuestion() // Put first question in next question slot ready for user to start quiz
        updateDisplay()
    }
    
    private func loadNextQuestion() {
        if let q = quiz, next_question != nil {
            prev_question = curr_question
            curr_question = next_question
            next_question = q.next()
        }
    }
    
    private func loadPrevQuestion() {
        if let q = quiz, curr_question != nil {
            next_question = curr_question
            curr_question = prev_question
            prev_question = q.prev()
        }
    }
    
    private func updateDisplay() {
        if let _ = curr_question {
            // display a question
        } else {
            // display the quiz description
            if let q = quiz {
                titleCard.text = q.title
                for view in containerView.subviews {
                    view.removeFromSuperview()
                }
                containerView.addSubview(contentQuizView.view)
                contentQuizView.descriptionText.text = q.description ?? "No Description"
            }
        }
    }
    
    
    
    
    private func loadQuizDisplay() {
        contentQuizView = QuizContentTemplate(frame: containerView.bounds)
        //contentQuizView = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuizContentTemplate") as! QuizDescriptionContentView)
        //contentQuizView.loadView()
    }
    
    private func loadQuestionDisplay() {
        //contentQuestionView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuestionContentTemplate") as? QuestionContentView
        //contentQuestionView.loadView()
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
