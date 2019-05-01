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
    private var driver = MultiPeerDriver.multipeerdriver
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let id = segue.identifier{
            switch (id)
            {
            case "TeacherDisconnect":
                let roomsVC = segue.destination as! AvailableRoomsTableVC
                roomsVC.availableRooms.removeAll()
            default: break
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        let quizSelector : Selector = #selector(handleNotificationStartNewQuiz(_:))
        NotificationCenter.default.addObserver(self, selector: quizSelector, name: NSNotification.Name(rawValue: "StartNewQuiz"), object: model)
        NotificationCenter.default.addObserver(self, selector: #selector(teacherDisconnect(_:)), name: .teacherDisconnect, object: nil)
    }
    
    @objc func teacherDisconnect(_ notification: Notification)
    {
        self.performSegue(withIdentifier: "TeacherDisconnect", sender: nil)
    }
    
    @objc func handleNotificationStartNewQuiz(_ notification: Notification)
    {
        if let userInfo = notification.userInfo, let q = userInfo[NotificationUserData.quizReceived.rawValue] as? QuizViewModel?
        {
            //let message = (quiz) ? "Dealer Won" : "You Won!"
            let alert = UIAlertController(title: "Quiz!", message: "The instructor has sent you a quiz.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Start Quiz", style: .default, handler:({(_: UIAlertAction) -> Void in self.start(quiz: q)}))
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func testQuiz(_ sender: UIBarButtonItem) {
        model.displayQuizFromTeacher(quiz: QuizViewModel())
    }
    
    private func start(quiz: QuizViewModel?) {
        let viewController:QuizViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuizViewController") as! QuizViewController
        viewController.modalPresentationStyle = UIModalPresentationStyle.custom
        viewController.quiz = quiz
        self.present(viewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        model = ConnectionData.instance()
    }
}
