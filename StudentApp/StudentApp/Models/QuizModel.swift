//
//  QuizModel.swift
//  StudentApp
//
//  Created by Ellis Saupe on 5/1/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import Foundation

class Quiz : Codable
{
    var title: String?
    var description: String?
    var questions: [Question]
    
    init(title: String, description: String, questions: [Question])
    {
        self.title = title
        self.description = description
        self.questions = questions
    }
}

class QuizViewModel : Codable {
    static let TestQuiz: Quiz = Quiz(title: "Test Quiz", description: "This quiz should have 1 question.", questions: [Question(name: "Test Question")])
    
    var title: String?
    var description: String?
    private var questions: [Question]
    private var curr_question: Int
    fileprivate init (_ questions: [Question]) {
        self.questions = questions
        self.curr_question = -1 // the index starts at -1 for the initial call to next getting question 1
    }
    
    static func from(quiz: Quiz) -> QuizViewModel {
        let model = QuizViewModel (quiz.questions)
        model.title = quiz.title
        model.description = quiz.description
        return model
    }
    
    // keeps the index from going past count so that it can pong between -1 and count, both represent nil
    private func incrementIndex() -> Int {
        curr_question = min(questions.count,curr_question+1)
        return curr_question
    }
    
    // keeps the index from going past -1 so that it can pong between -1 and count, both represent nil
    private func decrementIndex() -> Int {
        curr_question = max(-1,curr_question-1)
        return curr_question
    }
    
    private func peek(at index: Int) -> Question? {
        return 0 <= index && index < questions.count ? questions[curr_question] : nil
    }
    
    func next () -> Question? {
        return peek(at: incrementIndex())
    }
    
    func prev () -> Question? {
        return peek(at: decrementIndex())
    }
}

/*
 class Room
 {
 var name: String
 var peer: MCPeerID
 init(name: String, peer: MCPeerID)
 {
 self.name = name
 self.peer = peer
 }
 }*/

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
    
    init(isCorrect: Bool, text: String)
    {
        self.isCorrect = isCorrect
        self.text = text
    }
}

//Maintains a list of answer indices to pass to json
class StudentAnswer : Codable
{
    var displayName = ""
    var answers = [Int]()
    
    init(answerIndeces: [Int])
    {
        answers = answerIndeces
    }
}

