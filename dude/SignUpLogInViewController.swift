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
                
                self.saveUsersInfo(uid: Auth.auth().currentUser!.uid, email: Auth.auth().currentUser!.email!, profilePicUrl: "")
                
                self.performSegue(withIdentifier: "signUpToProfile", sender: self)
//                self.performSegue(withIdentifier: "logInSignUpToChatroom", sender: self)
            }
            else{
//                print("Error: \((error?.localizedDescription)!)")
//                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
//                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//
//                alertController.addAction(defaultAction)
//                self.present(alertController, animated: true, completion: nil)
                
                self.showAlert(title: "Error", message: error!.localizedDescription)
            }
        }
    }
    
    @IBAction func logIn(_ sender: Any) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            if error == nil {
                print("\(Auth.auth().currentUser!.email!) has logged in")
                self.performSegue(withIdentifier: "logInSignUpToChatroom", sender: self)
            } else {
//                print("Error: \((error?.localizedDescription)!)")
//                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
//                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//
//                alertController.addAction(defaultAction)
//                self.present(alertController, animated: true, completion: nil)
                
                self.showAlert(title: "Error", message: error!.localizedDescription)
            }
        }
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: self.email.text!) { (error) in
//            var title = String()
//            var message = String()
            
            if error == nil {
//                print("password reset email sent to \(self.email.text!)")
//                title = "Success!"
//                message = "Password reset email sent to \(self.email.text!)"
                
                self.showAlert(title: "Success!", message: "Password reset email sent to \(self.email.text!)")
            } else {
//                print("Error: \((error?.localizedDescription)!)")
//                title = "Error!"
//                message = (error?.localizedDescription)!
                
                self.showAlert(title: "Error", message: error!.localizedDescription)
            }
            
//            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//
//            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//            alertController.addAction(defaultAction)
//
//            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func saveUsersInfo(uid: String, email: String, profilePicUrl: String) {
        let database = Firestore.firestore()
        
        database.collection("users").document(uid).setData([
            "email": email,
            "profilePicUrl": profilePicUrl,
        ]) { (error) in
            if error == nil {
                print("User profile created for uid: \(uid), email: \(email), profilePicUrl: \(profilePicUrl)")
//                self.performSegue(withIdentifier: "signUpToProfile", sender: self)
//                self.performSegue(withIdentifier: "signUpToChatroom", sender: self)
            } else {
//                print("Error creating user profile: \(error!.localizedDescription)")
//
//                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
//                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//
//                alertController.addAction(defaultAction)
//                self.present(alertController, animated: true, completion: nil)
                
                self.showAlert(title: "Error", message: error!.localizedDescription)
                
                
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
            print("already logged in: \(Auth.auth().currentUser!.email!)")
            self.performSegue(withIdentifier: "alreadyLoggedIn", sender: nil)
        }
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
