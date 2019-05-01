//
//  DiscussionPostModel.swift
//  TeacherApp
//
//  Created by Ellis Saupe on 4/29/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import Foundation

class DiscussionPost : Codable
{
    var text: String
    var sender: String
    var isTeacher = true
    
    init(text: String, sender: String)
    {
        self.text = text
        self.sender = sender
    }
}
