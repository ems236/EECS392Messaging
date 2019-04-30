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

class Quiz : Codable {
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
    
    // keeps the index from going past count so that it can pong between -1 and count, both represent nil
    private func incrementIndex() {
        curr_question = min(questions.count,curr_question+1)
    }
    
    // keeps the index from going past -1 so that it can pong between -1 and count, both represent nil
    private func decrementIndex() {
        curr_question = max(-1,curr_question-1)
    }
    
    func next () -> Question? {
        incrementIndex()
        return curr_question < questions.count ? questions[curr_question] : nil
    }
    
    func prev () -> Question? {
        decrementIndex()
        return curr_question >= 0 ? questions[curr_question] : nil
    }
}

class Question : Codable {
    var name: String
    var answers: [Answer] = [Answer]()
    init (name: String) {
        self.name = name
        //self.answers = answers
    }
}

class Answer : Codable
{
    var isCorrect : Bool
    var text : String
    var letter : String
    
    init(isCorrect: Bool, text: String, letter: String)
    {
        self.isCorrect = isCorrect
        self.text = text
        self.letter = letter
    }
}
