//
//  RoomCell.swift
//  StudentApp
//
//  Created by Ellis Saupe on 4/28/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class RoomCell: UITableViewCell {

    @IBOutlet weak var Title: UILabel!
    private var peer : MCPeerID? = nil
    func setPeer(_ newpeer: MCPeerID)
    {
        peer = newpeer
        Title.text = newpeer.displayName
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
