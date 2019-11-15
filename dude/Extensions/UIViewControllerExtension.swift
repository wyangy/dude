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
    
    func showAlert(title: String, message: String) {
        print("\(title): \(message)")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
