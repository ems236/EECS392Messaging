//
//  StudentTabBarController.swift
//  StudentApp
//
//  Created by Jackson Nelson-Gal on 4/27/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import UIKit

class StudentTabBarController: UITabBarController {

    private weak var model: ConnectionData!
    private var driver = MultiPeerDriver.instance
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let id = segue.identifier{
            switch (id)
            {
            case "TeacherDisconnect":
                //I guess there isn't really any setup for this.
                print("Diconnecting teacher")
            default: break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        model = ConnectionData.instance()
        
        //Preload all tabs
        if let viewControllers = self.viewControllers
        {
            for viewController in viewControllers
            {
                let _ = viewController.view
            }
        }
        
        let quizSelector : Selector = #selector(handleNotificationStartNewQuiz(_:))
        NotificationCenter.default.addObserver(self, selector: quizSelector, name: .quizReceived, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(teacherDisconnect(_:)), name: .teacherDisconnect, object: nil)
    }
    
    @objc
    func teacherDisconnect(_ notification: Notification)
    {
        DispatchQueue.main.async
        {
            self.performSegue(withIdentifier: "TeacherDisconnect", sender: nil)
        }
    }
    
    @objc
    func handleNotificationStartNewQuiz(_ notification: Notification)
    {
        if let userInfo = notification.userInfo, let q = userInfo[NotificationUserData.quizReceived.rawValue] as? Quiz
        {
            let quizModel = QuizViewModel.from(quiz: q)
            //let message = (quiz) ? "Dealer Won" : "You Won!"
            let alert = UIAlertController(title: "Quiz!", message: "The instructor has sent you a quiz.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Start Quiz", style: .default, handler:({(_: UIAlertAction) -> Void in self.start(quiz: quizModel)}))
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func testQuiz(_ sender: UIBarButtonItem)
    {
        model.displayQuizFromTeacher(quiz: QuizViewModel.TestQuiz)
    }
    
    private func start(quiz: QuizViewModel?)
    {
        let viewController:QuizViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuizViewController") as! QuizViewController
        viewController.modalPresentationStyle = UIModalPresentationStyle.custom
        viewController.quiz = quiz
        self.present(viewController, animated: true, completion: nil)
    }
}
