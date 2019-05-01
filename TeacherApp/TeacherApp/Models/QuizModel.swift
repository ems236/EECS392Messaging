//
//  QuizModel.swift
//  TeacherApp
//
//  Created by Ellis Saupe on 4/28/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import Foundation

/* Placeholders for now */
fileprivate class QuizBuilder {
    private var questions: [Question]
    init () {
        questions = [Question]()
    }
    func add(question: Question) {
        questions.append(question)
    }
    func build() -> Quiz {
        return Quiz(self.questions)
    }
}

class Quiz : Codable
{
    var title: String?
    var description: String?
    var questions: [Question]
    private var curr_question: Int
    fileprivate init (_ questions: [Question]) {
        self.questions = questions
        self.curr_question = -1 // the index starts at -1 for the initial call to next getting question 1
    }
    
    static func emptyQuiz() -> Quiz
    {
        return Quiz([Question]())
    }
    
    /* for testing */
    convenience init () {
        self.init([Question(name: "Test Question")])
        self.title = "Test Quiz"
        self.description = "There is 1 question on this quiz"
    }
}

class Question : Codable
{
    var name: String
    var answers: [Answer] = [Answer]()
    
    func getAnswer(_ index: Int) -> Answer?
    {
        if index < answers.count && index >= 0
        {
            return answers[index]
        }
        else
        {
            return nil
        }
    }
    
    init (name: String) {
        self.name = name
        //self.answers = answers
    }
}

class Answer : Codable
{
    var isCorrect : Bool
    var text : String
    
    init(isCorrect: Bool, text: String)
    {
        self.isCorrect = isCorrect
        self.text = text
    }
}

class StudentAnswer : Codable
{
    var displayName : String
    var answers = [Int]()
    
    init(name: String, answerIndeces: [Int])
    {
        self.displayName = name
        answers = answerIndeces
    }
}

class QuestionAnswer
{
    var name : String
    var answerIndex : Int
    
    init(name: String, answerIndex: Int)
    {
        self.name = name
        self.answerIndex = answerIndex
    }
}
