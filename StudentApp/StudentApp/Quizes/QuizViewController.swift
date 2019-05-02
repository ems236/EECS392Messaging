//
//  QuizViewController.swift
//  StudentApp
//
//  Created by Jackson Nelson-Gal on 4/27/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    
    var quiz: QuizViewModel?
    @IBOutlet weak var quizView: UIView!
    private weak var prev_question: Question?
    private weak var curr_question: Question?
    private weak var next_question: Question?
    
    private var contentQuizView: QuizContentTemplate!
    private var contentQuestionViews: [QuestionContentTemplate]!
    
    // Content in content view
    @IBOutlet weak var titleCard: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    
    private var radius: CGFloat!
    
    override func viewDidLoad() {
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
    
    @IBAction func buttonClick(_ sender: UIButton) {
        switch (sender) {
        case submitButton:
            if let _ = next_question {
                loadNextQuestion()
                updateDisplay()
            } else {
                // Quiz is done
                quiz = nil
                self.dismiss(animated: true, completion: nil)
            }
        default:
            return
        }
    }
    
    private func loadNextQuestion() {
        if let q = quiz {
            if next_question != nil {
                prev_question = curr_question
                curr_question = next_question
            }
            next_question = q.next()
        }
    }
    
    private func loadPrevQuestion() {
        if let q = quiz {
            if curr_question != nil {
                next_question = curr_question
                curr_question = prev_question
            }
            prev_question = q.prev()
        }
    }
    
    private func updateDisplay() {
        if let _ = curr_question {
            // display a question
            for view in containerView.subviews {
                view.removeFromSuperview()
            }
            containerView.addSubview(contentQuestionViews[0].view)
        } else {
            // display the quiz description
            if let q = quiz {
                titleCard.text = q.title
                for view in containerView.subviews {
                    view.removeFromSuperview()
                }
                containerView.addSubview(contentQuizView.view)
                contentQuizView.descriptionText.text = q.description ?? "No Description"
                submitButton.setTitle("First Question", for: .normal)
            }
        }
    }
    
    
    
    
    
    private func loadQuizDisplay() {
        contentQuizView = QuizContentTemplate(frame: containerView.bounds)
    }
    
    private func loadQuestionDisplay() {
        contentQuestionViews = [QuestionContentTemplate]()
        contentQuestionViews.append(QuestionMultipleChoiceTemplate(frame: containerView.bounds))
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
