//
//  ProfileViewController.swift
//  dude
//
//  Created by Wendy Yang on 2019/3/22.
//  Copyright © 2019 wyangy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    
    @IBAction func submit(_ sender: Any) {
        let database = Firestore.firestore()
        
        database.collection("users").document("\(Auth.auth().currentUser!.uid)").setData([
            "username": "\(Auth.auth().currentUser!.displayName!)",
            "email": "\(Auth.auth().currentUser!.email!)",
            
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("User profile created:\(Auth.auth().currentUser!.displayName!), \(Auth.auth().currentUser!.email!)")
                
                self.performSegue(withIdentifier: "profileToChat", sender: self)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
