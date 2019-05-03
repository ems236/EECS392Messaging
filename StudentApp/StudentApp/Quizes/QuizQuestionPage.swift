//
//  QuizQuestionPage.swift
//  StudentApp
//
//  Created by Ellis Saupe on 5/2/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import UIKit

class QuizQuestionPage: UIViewController
{
    var question: Question!
    var questionIndex: Int!
    var pageController: QuizPageController!
    @IBOutlet weak var QuestionTitle: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        QuestionTitle.text = question.name
        // Do any additional setup after loading the view.
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
