//
//  LogInViewController.swift
//  Messenger-app
//
//  Created by Sailor on 08/05/2020.
//  Copyright © 2020 com.sailor. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD
import FBSDKLoginKit
import GoogleSignIn

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        guard let email = emailTextField.text, let pass = passwordTextField.text else{
             let alertView = UIAlertController(title: "Error", message: "Debe ingresar valores", preferredStyle: .alert)
                             
               alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                             
               self.present(alertView, animated: true, completion: nil)
                            
               return
              }
        
        SVProgressHUD.show()
        
        Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
            if error != nil {
                let alertView = UIAlertController(title: "Error", message: error.debugDescription, preferredStyle: .alert)
                  alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                  self.present(alertView, animated: true, completion: nil)
                 SVProgressHUD.dismiss()
            } else {
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "fromLoginToChat", sender: self)
            }
        }
    }
    
    @IBAction func facebookLogIn(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: [.email], viewController: self) { (result) in
           
            switch result{
            case .success(granted: let granted, declined: let declined, token: let token):
                
                let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                
                Auth.auth().signIn(with: credential) { (result,error) in
                     self.performSegue(withIdentifier: "fromLoginToChat", sender: self)
                }
            case .cancelled:
                break
            case .failed(_):
                //error
                break
            }
            
        }
    }
    
    
    @IBAction func googleLogIn(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance()?.signIn()
    }
    
}


extension LoginViewController: GIDSignInDelegate{
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil && user.authentication != nil{
            let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { (result, error) in
                 self.performSegue(withIdentifier: "fromLoginToChat", sender: self)
            }
        }
    }
    
}

