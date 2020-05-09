//
//  Message.swift
//  Messenger-app
//
//  Created by Sailor on 06/05/2020.
//  Copyright © 2020 com.sailor. All rights reserved.
//

class Message {
    var sender : String = ""
    var body : String = ""
    
    init(sender: String, body: String){
        self.sender = sender
        self.body = body
    }
    
   
        init(){
              sender = "Martin"
              body = "Esto es un mensaje de prueba para la aplicación"
          }
    
}

