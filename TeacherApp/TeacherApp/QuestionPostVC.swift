//
//  QuestionPostVC.swift
//  TeacherApp
//
//  Created by Ellis Saupe on 4/29/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import UIKit

class QuestionPostVC: UIViewController {

    var question : TeacherQuestion = TeacherQuestion.testQuestion()
    
    @IBOutlet weak var BodyLabel: UILabel!
    @IBOutlet weak var HeadLabel: UILabel!
    
    @IBAction func DeleteQuestion(_ sender: Any)
    {
        self.performSegue(withIdentifier: "DeleteQuestion", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let id = segue.identifier
        {
            switch id
            {
            case "DeleteQuestion":
                let tableVC = segue.destination as! QuestionsTableVC
                tableVC.deleteQuestion(question)
            default: break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
