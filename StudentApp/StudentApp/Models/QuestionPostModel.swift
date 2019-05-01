//
//  QuestionPostModel.swift
//  StudentApp
//
//  Created by Ellis Saupe on 5/1/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import Foundation

class TeacherQuestion : Codable, Equatable
{
    static func testQuestion() -> TeacherQuestion
    {
        return TeacherQuestion(head: "My head", body: "Whoa that's a lot of text wowee this is a long question come on student I'm teaching here calm down")
    }
    
    static func == (lhs: TeacherQuestion, rhs: TeacherQuestion) -> Bool {
        return lhs.header == rhs.header && lhs.body == rhs.body
    }
    
    var header: String
    var body: String
    
    init(head: String, body: String)
    {
        self.header = head
        self.body = body
    }
}
