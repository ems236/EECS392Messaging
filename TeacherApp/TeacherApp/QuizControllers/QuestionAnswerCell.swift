//
//  QuestionAnswerCell.swift
//  TeacherApp
//
//  Created by Ellis Saupe on 4/30/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import UIKit

class QuestionAnswerCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var NameLabel: UILabel!
    
    func setName(name: String, isCorrect: Bool)
    {
        NameLabel.text = name
        NameLabel.textColor = isCorrect ? .black : .red
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
