//
//  SignUpLogInViewController.swift
//  dude
//
//  Created by Wendy Yang on 2019/3/2.
//  Copyright © 2019 wyangy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpLogInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func signUp(_ sender: Any) {
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (user, error) in
            if error == nil {
                print("\(self.email.text!) has signed up")
                
                self.saveUsersInfo(email: Auth.auth().currentUser!.email!, profilePicUrl: "")
                
                self.performSegue(withIdentifier: "signUpToProfile", sender: self)
            } else {
                self.showAlert(title: "Error", message: error!.localizedDescription)
            }
        }
    }
    
    @IBAction func logIn(_ sender: Any) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            if error == nil {
                print("\(Auth.auth().currentUser!.email!) has logged in")
                
                self.checkUserProfileExists(email: Auth.auth().currentUser!.email!)
                    
                self.performSegue(withIdentifier: "logInSignUpToChatroom", sender: self)
            } else {
                self.showAlert(title: "Error", message: error!.localizedDescription)
            }
        }
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: self.email.text!) { (error) in
            if error == nil {
                self.showAlert(title: "Success!", message: "Password reset email sent to \(self.email.text!)")
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) { // why viewDidAppear instead of viewDidLoad?
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            self.checkUserProfileExists(email: Auth.auth().currentUser!.email!)
            
            print("already logged in: \(Auth.auth().currentUser!.email!)")
            self.performSegue(withIdentifier: "alreadyLoggedIn", sender: nil)
        }
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}


