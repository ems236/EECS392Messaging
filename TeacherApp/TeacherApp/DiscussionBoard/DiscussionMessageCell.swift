//
//  DiscussionMessageCell.swift
//  TeacherApp
//
//  Created by Ellis Saupe on 5/1/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import UIKit

class DiscussionMessageCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var MessageText: UILabel!
    
    func setMessage(_ message: DiscussionPost)
    {
        NameLabel.text = message.sender
        MessageText.text = message.text
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
