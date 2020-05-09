//
//  MessageCell.swift
//  Messenger-app
//
//  Created by Sailor on 08/05/2020.
//  Copyright © 2020 com.sailor. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.messageView.layer.cornerRadius = 8.0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

