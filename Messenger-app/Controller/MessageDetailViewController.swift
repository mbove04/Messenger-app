//
//  MessageDetailViewController.swift
//  Messenger-app
//
//  Created by Sailor on 08/05/2020.
//  Copyright © 2020 com.sailor. All rights reserved.
//

import UIKit

class MessageDetailViewController: UIViewController {

    var delegate: ChatViewController?
    var messageText = ""
    
    @IBOutlet weak var labelDetail: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelDetail.text = messageText
    }

}
