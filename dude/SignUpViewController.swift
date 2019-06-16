//
//  SignUpViewController.swift
//  dude
//
//  Created by Wendy Yang on 2019/3/2.
//  Copyright © 2019 wyangy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func signUp(_ sender: Any) {
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (user, error) in
            if error == nil {
                print("\(self.email.text!) has signed up")
//                self.performSegue(withIdentifier: "signUpToProfile", sender: self)
                self.performSegue(withIdentifier: "signUpToChatroom", sender: self)
            }
            else{
                print("Error: \((error?.localizedDescription)!)")
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
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
