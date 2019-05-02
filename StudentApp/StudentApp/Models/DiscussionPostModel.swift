//
//  DiscussionPostModel.swift
//  StudentApp
//
//  Created by Ellis Saupe on 5/1/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import Foundation

class DiscussionPost : Codable
{
    var text: String
    var sender: String
    var isTeacher = false
    
    init(text: String, sender: String)
    {
        self.text = text
        self.sender = sender
    }
}
