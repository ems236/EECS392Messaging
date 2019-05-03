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
        if let id = segue.identifier
        {
            switch (id)
            {
            case "SubmitQuiz":
                print("submitted quiz")
            default: break
            }
        }
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
        //Initialize answers array
        initAnswers()
        self.title = quiz.title
        self.navigationItem.rightBarButtonItem = nil
        dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        self.navigationItem.hidesBackButton = true
    }
    
    var quiz: Quiz!
    private var answers = [Int?]()
    private var quizQuestionVCs = [QuizQuestionPage]()
    
    @IBOutlet var SubmitBtn: UIBarButtonItem!
    @IBAction func SubmitBtnClick(_ sender: Any)
    {
        submitQuiz()
    }
    private func makeControllersForQuiz() -> [QuizQuestionPage]
    {
        var quizes = [QuizQuestionPage]()
        for index in 0 ..< quiz.questions.count
        {
            let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuizQuestionPage") as! QuizQuestionPage
            newVC.question = quiz.questions[index]
            newVC.questionIndex = index
            newVC.pageController = self
            
            if index == 0
            {
                newVC.hidePrev = true
            }
            if index == quiz.questions.count - 1
            {
                newVC.hideNext = true
            }
            quizes.append(newVC)
        }
        return quizes
    }
    
    func moveNext()
    {
        if let currentPage = self.viewControllers?.first, let next = dataSource?.pageViewController(self, viewControllerAfter: currentPage)
        {
            self.setViewControllers([next], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func moveLast()
    {
        if let currentPage = self.viewControllers?.first, let last = dataSource?.pageViewController(self, viewControllerBefore: currentPage)
        {
            self.setViewControllers([last], direction: .reverse, animated: true, completion: nil)
        }
    }
    
    private func initAnswers()
    {
        for _ in quiz.questions
        {
            answers.append(nil)
        }
        print(answers.count)
        print(quiz.questions.count)
    }
    
    func setAnswer(_ answer: Int, atIndex index: Int)
    {
        print("Setting answer to " + String(index) + " as " + String(answer))
        if inRange(index: index, list: quiz.questions) && inRange(index: answer, list: quiz.questions[index].answers)
        {
            print("Setting answer to " + String(index) + " as " + String(answer))
            answers[index] = answer
        }
        
        if allItemsSet(answers)
        {
            print("Adding button")
            print(SubmitBtn)
            self.navigationItem.rightBarButtonItem = SubmitBtn
            //self.navigationItem.rightBarButtonItem = AddButton
        }
    }
    
    func submitQuiz()
    {
        let _ = MultiPeerDriver.instance.submitQuizAnswers(StudentAnswer(answerIndeces: unwrapAnswers()))
        self.performSegue(withIdentifier: "SubmitQuiz", sender: nil)
    }
    
    private func unwrapAnswers() -> [Int]
    {
        return answers.map({ (num) -> Int in
            if let val = num
            {
                return val
                
            }
            else
            {
                return 0
            }
        })
    }
    
    private func allItemsSet(_ list: [Any?]) -> Bool
    {
        return list.filter({$0 == nil}).count == 0
    }
    
    private func inRange(index: Int, list: [Any]) -> Bool
    {
        return 0 <= index && index < list.count
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
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int
    {
        return quizQuestionVCs.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
}
