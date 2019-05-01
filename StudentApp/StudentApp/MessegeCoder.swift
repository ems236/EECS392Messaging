//
//  MessegeCoder.swift
//  StudentApp
//
//  Created by Ellis Saupe on 4/28/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import Foundation
import MultipeerConnectivity

enum MessageTypes: UInt8
{
    case error = 0
    case quiz = 1
    case answers = 2
    case question = 3
    case message = 4
}

protocol MessegeReceiverDelegate
{
    func receiveQuiz(_ quiz: Quiz)
    func receiveAnswers(_ answers: StudentAnswer)
    func receiveDiscussionPost(_ message: DiscussionPost)
    func receiveQuestionPost(_ question: TeacherQuestion)
}

class MessageCoder
{
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    var delegate: MessegeReceiverDelegate? = nil
    
    func encodeMessage<T : Encodable>(_ object: T, type: MessageTypes) -> Data?
    {
        let jsonMaybe = try? encoder.encode(object)
        if let json = jsonMaybe
        {
            var data = uint8ToData(type.rawValue)
            data.append(json)
            return data
        }
        return nil
    }

    func decodeMessage(_ message: Data)
    {
        //read fist byte
        guard let typeEnum = MessageTypes(rawValue: [UInt8](message).first ?? 0)
            else
        {
            return
        }
        
        let messageBody = message.advanced(by: 1)
        
        switch typeEnum {
        case .message:
            print("Received message post")
            if let post = try? decoder.decode(DiscussionPost.self, from: messageBody)
            {
                delegate?.receiveDiscussionPost(post)
            }
        case .quiz:
            if let quiz = try? decoder.decode(Quiz.self, from: messageBody)
            {
                delegate?.receiveQuiz(quiz)
            }
            print("received quiz")
        case .answers:
            if let answers = try? decoder.decode(StudentAnswer.self, from: messageBody)
            {
                delegate?.receiveAnswers(answers)
            }
            print("answers")
        case .question:
            print("Question received")
            if let question = try? decoder.decode(TeacherQuestion.self, from: messageBody)
            {
                print("Decoded question")
                delegate?.receiveQuestionPost(question)
            }
        default:
            return
        }
    }

    func uint8ToData(_ value: UInt8) -> Data
    {
        var copy = value
        return Data(bytes: &copy, count: MemoryLayout.size(ofValue: copy))
    }
}
