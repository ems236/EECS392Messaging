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
    @IBOutlet weak var quizContentView: UIView!
    
    // Content in content view
    @IBOutlet weak var titleCard: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    private var radius: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        radius = quizContentView.frame.width/15
        quizContentView.layer.cornerRadius = radius
        quizContentView.clipsToBounds = false
        titleCard.text = "QUIZ!"
        submitButton.layer.cornerRadius = radius
    }
    
    private func loadNextQuestion() {
        if let _ = quiz {
            
        }
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
