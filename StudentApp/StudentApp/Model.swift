//
//  Model.swift
//  StudentApp
//
//  Created by Jackson Nelson-Gal on 4/27/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import Foundation
//import MultipeerConnectivity

class ConnectionData {
    //what exactly is the purpose of having a private instance with a getter?
    //Just a java habit?
    private static let SHARED_INSTANCE = ConnectionData()
    static func instance() -> ConnectionData { return SHARED_INSTANCE }
    
    private var isLive: Bool
    private var currentSlide: Int
    private var _teacherSlide: Int
    private var teacherSlide: Int {
        get { return _teacherSlide }
        set {
            _teacherSlide = newValue
            if isLive { currentSlide = _teacherSlide }
        }
    }
    var displayedSlide: Int { get { return isLive ? teacherSlide : currentSlide } }
    
    /* private var connection: SessionToTeacher? <-- Don't know what this should look like */
    
    private init () { _teacherSlide = 0; currentSlide = 0; isLive = true }
    
    func submitQuestionToTeacher (header: String, desc: String, slide: Int?) {
        /* Should transfer this data to the teacher host in a way that the teacher app knows its a question */
    }
    
    func displayQuizFromTeacher (quiz: Quiz) {
        /* This method should be called by whatever finds out when the teacher gives us info. If it is a quiz, it should create the question objects and overall quiz object to pass in here. */
        NotificationCenter.default.post(name: Notification.Name(rawValue: "StartNewQuiz"), object: self, userInfo: ["quiz" : quiz])
    }
    
    func submitQuizAnswers (answers: AnswerSheet) {
        /*  */
    }
}

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
    private let questions: [Question]
    private var curr_question: Int
    fileprivate init (_ questions: [Question]) {
        self.questions = questions
        self.curr_question = -1 // the index starts at -1 for the initial call to next getting question 1
    }
    /* for testing */
    convenience init () {
        self.init([Question(name: "Test Question")])
        self.title = "Test Quiz"
        self.description = "There is 1 question on this quiz"
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
    var letter : String
    
    init(isCorrect: Bool, text: String, letter: String)
    {
        self.isCorrect = isCorrect
        self.text = text
        self.letter = letter
    }
}

class AnswerSheet {}

class DiscussionPost : Codable {}
class TeacherQuestion : Codable {}
