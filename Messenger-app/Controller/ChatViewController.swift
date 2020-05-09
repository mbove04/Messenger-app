//
//  ChatViewController.swift
//  Messenger-app
//
//  Created by Sailor on 08/05/2020.
//  Copyright © 2020 com.sailor. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import ChameleonFramework
import FBSDKLoginKit
import GoogleSignIn

class ChatViewController: UIViewController {

    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textBoxHeight: NSLayoutConstraint!
    
    var messagesArray : [Message]  = [Message]()
    var messageTextDetail = "OK"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.messagesTableView.delegate = self
        self.messagesTableView.dataSource = self
        self.messageTextField.delegate = self

        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideMessageZone))
        self.messagesTableView.addGestureRecognizer(tapGesture)
        
        
        self.messagesTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCellID")
        self.messagesTableView.separatorStyle = .none
        
        configureTableView()
        retrieveMessagesFromFirebase()
    }
    
    //Establece el tamaño correcto para cada una de las celdas de la tabla
    func configureTableView() {
        self.messagesTableView.rowHeight = UITableView.automaticDimension
        self.messagesTableView.estimatedRowHeight = 200
    }


    
    /*
     MARK: - Firebase Methods
     */

    @IBAction func logoutPressed(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            LoginManager().logOut()
            GIDSignIn.sharedInstance()?.signOut()
            
        } catch {
            print("Error: no se ha podido hacer un sign out")
        }
        
        
        guard navigationController?.popToRootViewController(animated: true) != nil else {
            print("No hay view controllers que eliminar de la stack")
            return
        }
        
        
    }
    
    
    @IBAction func sendPressed(_ sender: UIButton) {
        self.messageTextField.endEditing(true)
        
        messageTextField.isEnabled = false
        sendButton.isEnabled = false
        
        let messagesDB = Database.database().reference().child("Messages")
        let messageDict = ["sender": Auth.auth().currentUser?.email,
                           "body" : self.messageTextField.text!]
        
        messagesDB.childByAutoId().setValue(messageDict) { (error, ref) in
            if error != nil {
                print(error!)
            } else {
                print("Mensaje guardado correctamente")
                
                self.messageTextField.isEnabled = true
                self.sendButton.isEnabled = true
                
                self.messageTextField.text = ""
            }
        }
        
    }
    
    //funcion con observer a firebase 
    func retrieveMessagesFromFirebase(){
        let messagesDB = Database.database().reference().child("Messages")
        messagesDB.observe(.childAdded) { (snapshot) in
            let snpValue = snapshot.value as! Dictionary<String, String>
            
            let sender = snpValue["sender"]!
            let body = snpValue["body"]!
            
            let message = Message(sender: sender, body: body)
            self.messagesArray.append(message)
            
            self.configureTableView()
            self.messagesTableView.reloadData()
        }
    }
    
    //segue con metodo delegado
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail" {
            let destination = segue.destination as! MessageDetailViewController
            
            destination.messageText = messageTextDetail
            destination.delegate = self
        }
    }
}


extension ChatViewController: UITableViewDataSource, UITableViewDelegate{
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCellID", for: indexPath) as! MessageCell
        
        cell.usernameLabel.text = messagesArray[indexPath.row].sender
        cell.messageLabel.text = messagesArray[indexPath.row].body
        cell.messageImageView.image = UIImage(named: "avatar")
        
        if cell.usernameLabel.text == Auth.auth().currentUser?.email {
            cell.messageImageView.backgroundColor = UIColor.flatLime()
            cell.messageView.backgroundColor = UIColor.flatSkyBlue()
        }else {
            cell.messageImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageView.backgroundColor = UIColor.flatGray()
        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow
        let cell = tableView.cellForRow(at: indexPath!)! as! MessageCell
        
      
        self.messageTextDetail = cell.messageLabel.text!
        
        performSegue(withIdentifier: "goToDetail", sender: nil)
      
    }
    
    
}

extension ChatViewController: UITextFieldDelegate{
    
    //subo la view del texto al pulasar el teclado
    func textFieldDidBeginEditing(_ textField: UITextField) {
         UIView.animate(withDuration: 0.5) {
             self.textBoxHeight.constant = 70 + 245 //alto teclado
             self.view.layoutIfNeeded()
         }
     }
     
     func textFieldDidEndEditing(_ textField: UITextField) {
         hideMessageZone()
     }
     
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.endEditing(true)
         return true
     }
     
    //al ser selector va con @objc
     @objc func hideMessageZone(){
         self.messageTextField.resignFirstResponder()
         UIView.animate(withDuration: 0.5) {
             self.textBoxHeight.constant = 70
             self.view.layoutIfNeeded()
         }
     }
    
}
