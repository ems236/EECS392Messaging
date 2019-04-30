//
//  QuestionPostCell.swift
//  TeacherApp
//
//  Created by Ellis Saupe on 4/29/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import UIKit

class QuestionPostCell: UITableViewCell {

    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var TextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setQuestion(_ question: TeacherQuestion)
    {
        TitleLabel.text = question.header
        TitleLabel.text = question.body
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
