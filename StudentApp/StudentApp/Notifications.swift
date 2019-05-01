//
//  Notifications.swift
//  StudentApp
//
//  Created by Ellis Saupe on 4/28/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let discoveredTeacher = Notification.Name("discoveredTeacher")
    static let lostTeacher = Notification.Name("lostTeacher")
    static let teacherDisconnect = Notification.Name("teacherDC")
    static let quizReceived = Notification.Name("quizReceived")
    static let answerSubmitted = Notification.Name("answerReceived")
    static let messageReceived = Notification.Name("messageReceived")
    static let questionPosted = Notification.Name("questionReceived")
    static let studentJoined = Notification.Name("newStudent")
}

enum NotificationUserData: String
{
    case peerChange = "peer"
    case quizReceived = "quiz"
    case answersReceived = "answers"
    case messageReceived = "message"
    case questionPosted = "question"
}
