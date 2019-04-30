//
//  QuizQuestionCell.swift
//  TeacherApp
//
//  Created by Ellis Saupe on 4/30/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import UIKit

class QuizQuestionCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var QuestionLabel: UILabel!
    
    func setQuestion(_ question: Question)
    {
        QuestionLabel.text = question.name
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
