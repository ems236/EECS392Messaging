//
//  QuizResultsViewModel.swift
//  TeacherApp
//
//  Created by Ellis Saupe on 4/30/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import Foundation

class QuizResultsViewModel
{
    var quiz: Quiz
    var answers = [Answer]()
    
    init(quiz: Quiz, answers: [Answer])
    {
        self.quiz = quiz
        self.answers = answers
    }
}
