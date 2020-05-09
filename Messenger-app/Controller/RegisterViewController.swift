//
//  RegisterViewController.swift
//  Messenger-app
//
//  Created by Sailor on 05/05/2020.
//  Copyright © 2020 com.sailor. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
   
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var password2TextField: UITextField!
    
    @IBOutlet weak var conditionsSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        guard let email = emailTextField.text,!email.isEmpty, let pass = passwordTextField.text,!pass.isEmpty ,let pass2 = password2TextField.text,!pass2.isEmpty  else{
              let alertView = UIAlertController(title: "Error", message: "Debe ingresar valores", preferredStyle: .alert)
                              
                alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                              
                self.present(alertView, animated: true, completion: nil)
                             
                return
           }
        
        
        
        guard conditionsSwitch.isOn else {
                let alertView = UIAlertController(title: "Error", message: "Debe de aceptar la politica de privacidad", preferredStyle: .alert)
                
                alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alertView, animated: true, completion: nil)
               
            return
        }
        

        
        guard passwordTextField.text == password2TextField.text else {
             let alertView = UIAlertController(title: "Error", message: "Las contraseñas no coinciden", preferredStyle: .alert)
                          
                alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                          
                self.present(alertView, animated: true, completion: nil)
                         
                return
        }
        
        guard passwordTextField.text!.count > 5, password2TextField.text!.count > 5 else{
            let alertView = UIAlertController(title: "Error", message: "Contraseña tiene menos de 6 dígitos", preferredStyle: .alert)
                      
            alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                      
            self.present(alertView, animated: true, completion: nil)
                     
            return
        }
        
   
        
        SVProgressHUD.resetOffsetFromCenter()
        SVProgressHUD.show()
        
        
        
        Auth.auth().createUser(withEmail: email, password: pass) { (user, error) in
            if error != nil{
                let alertView = UIAlertController(title: "Error", message: "Posiblemente ingreso mal el correo", preferredStyle: .alert)
                                     
                alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                     
                self.present(alertView, animated: true, completion: nil)
                
                SVProgressHUD.dismiss()
            }else{
                    SVProgressHUD.dismiss()
                 self.performSegue(withIdentifier: "fromRegistryToChat", sender: self)
                }
            }
        
    }
    
}
