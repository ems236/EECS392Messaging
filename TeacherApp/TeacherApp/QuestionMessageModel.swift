//
//  QuestionMessageModel.swift
//  TeacherApp
//
//  Created by Ellis Saupe on 4/29/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import Foundation

class TeacherQuestion : Codable, Equatable
{
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
