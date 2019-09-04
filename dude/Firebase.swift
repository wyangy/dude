//
//  Firebase.swift
//  dude
//
//  Created by Wendy Yang on 2019/9/4.
//  Copyright © 2019 wyangy. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseDatabase
import FirebaseAuth

let databaseRef = Database.database().reference()

extension UIViewController {
    
    func saveUsersInfo(email: String, profilePicUrl: String) {        
        Firestore.firestore().collection("users").document(email).setData([
            "profilePicUrl": profilePicUrl,
        ]) { (error) in
            if error == nil {
                print("User profile created for email: \(email), profilePicUrl: \(profilePicUrl)")
            } else {
                self.showAlert(title: "Error", message: error!.localizedDescription)
            }
        }
    }
    
    func saveMessage(message: String) {
        databaseRef.child("posts").child(Date().description).setValue([
            "email": Auth.auth().currentUser!.email!,
            "message": message,
        ]) { (error:Error?, databaseRef:DatabaseReference) in
            if let error = error {
                self.showAlert(title: "Message could not be saved", message: error.localizedDescription)
            } else {
                print("Message saved successfully for email: \(Auth.auth().currentUser!.email!), message: \(message)")
            }
        }
    }
}
