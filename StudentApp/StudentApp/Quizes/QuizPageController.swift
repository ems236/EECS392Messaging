//
//  QuizPageController.swift
//  StudentApp
//
//  Created by Ellis Saupe on 5/2/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import UIKit

class QuizPageController: UIPageViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //Requires that a quiz is set to work
        quizQuestionVCs = makeControllersForQuiz()
        
        if let first = quizQuestionVCs.first
        {
            print("Controllers loaded")
            self.setViewControllers([first], direction: .forward, animated: false, completion: nil)
        }
        dataSource = self
    }
    
    var quiz: Quiz!
    private var quizQuestionVCs = [QuizQuestionPage]()
    
    private func makeControllersForQuiz() -> [QuizQuestionPage]
    {
        var quizes = [QuizQuestionPage]()
        for index in 0 ..< quiz.questions.count
        {
            let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuizQuestionPage") as! QuizQuestionPage
            newVC.question = quiz.questions[index]
            newVC.questionIndex = index
            newVC.quizTitle = quiz.title
            quizes.append(newVC)
        }
        return quizes
    }
    
}

extension QuizPageController: UIPageViewControllerDataSource
{
    private func getIndexOfVC(_ VC: UIViewController) -> Int?
    {
        guard let index = quizQuestionVCs.firstIndex(of: VC as! QuizQuestionPage)
        else
        {
            return nil
        }
        
        return index
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        if let index = getIndexOfVC(viewController), 0 <= index - 1 && index - 1 < quizQuestionVCs.count
        {
            return quizQuestionVCs[index - 1]
        }
        else
        {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        if let index = getIndexOfVC(viewController), 0 <= index + 1 && index + 1 < quizQuestionVCs.count
        {
            return quizQuestionVCs[index + 1]
        }
        else
        {
            return nil
        }
    }
}

extension QuizPageController: UIPageViewControllerDelegate
{
    
}
