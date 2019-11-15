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
                print("User profile saved for email: \(email), profilePicUrl: \(profilePicUrl)")
            } else {
                self.showAlert(title: "Error", message: error!.localizedDescription)
            }
        }
    }
    
    func checkUserProfileExists(email: String) {
        let firestoreRef = Firestore.firestore().collection("users").document(email)
        
        firestoreRef.getDocument { (document, error) in
            
            if error != nil {
                self.showAlert(title: "Error", message: error!.localizedDescription)
                return
            }
            
            if let document = document, document.exists {
                print("User profile for \(email) exists, logging in...")
            } else {
                print("User profile for \(email) does not exist, creating user profile now...")
                self.saveUsersInfo(email: email, profilePicUrl: "")
            }
        }
    }
    
}
