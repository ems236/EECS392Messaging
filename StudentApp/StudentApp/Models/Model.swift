//
//  Model.swift
//  StudentApp
//
//  Created by Jackson Nelson-Gal on 4/27/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import Foundation
//import MultipeerConnectivity

class ConnectionData
{
    //what exactly is the purpose of having a private instance with a getter?
    //Just a java habit?
    private static let SHARED_INSTANCE = ConnectionData()
    static func instance() -> ConnectionData { return SHARED_INSTANCE }
    
    private let multipeerdriver = MultiPeerDriver.instance
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
    
    func submitQuestionToTeacher (header: String, desc: String)
    {
        let question = TeacherQuestion(head: header, body: desc)
        let _ = multipeerdriver.postQuestion(question)
        /* Should transfer this data to the teacher host in a way that the teacher app knows its a question */
    }
    
    func displayQuizFromTeacher (quiz: Quiz) {
        /* This method should be called by whatever finds out when the teacher gives us info. If it is a quiz, it should create the question objects and overall quiz object to pass in here. */
        NotificationCenter.default.post(name: .quizReceived, object: self, userInfo: [NotificationUserData.quizReceived.rawValue : quiz])
    }
    
    func submitQuizAnswers (answers: AnswerSheet) {
        /*  */
    }
}

class AnswerSheet {}
