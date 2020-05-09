//
//  ViewController.swift
//  Messenger-app
//
//  Created by Sailor on 04/05/2020.
//  Copyright © 2020 com.sailor. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        SVProgressHUD.show()
        if Auth.auth().currentUser != nil {
            //el usuario ya está logeado
            SVProgressHUD.dismiss(withDelay: 0.5)
            self.performSegue(withIdentifier: "goToChat", sender: self)
        }else{
            SVProgressHUD.dismiss()
        }
        
    }


}
