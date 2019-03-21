//
//  ChatsViewController.swift
//  dude
//
//  Created by Wendy Yang on 2019/3/3.
//  Copyright © 2019 wyangy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ChatsViewController: UIViewController {

    @IBOutlet weak var usersTableView: UITableView!
    
    @IBAction func logOut(_ sender: Any) {
        do {
            print("\(Auth.auth().currentUser!.email!) has signed out")
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
    }
    
    @IBAction func addUser(_ sender: Any) {
        var userEmailTextField: UITextField?
        
        
        
        let alertController = UIAlertController(
            title: "Add user",
            message: "Please enter the email address of the user you want to add to your chats",
            preferredStyle: .alert)
        
        alertController.addTextField {
            (textUserEmail) -> Void in
            userEmailTextField = textUserEmail
            userEmailTextField!.placeholder = "User's email here"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let addUserAction = UIAlertAction(
        title: "Add", style: .default) {
            (action) -> Void in
            
//            if let username = userEmailTextField?.text {
//                print("added user: \(username)")
//            } else {
//                print("No Username entered")
//            }
            
            
            if (userEmailTextField?.text?.isEmpty)! {
                let alertController = UIAlertController(title: "Error", message: "User's email address cannot be empty", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil) // problem here is that after pressing cancel, it did not go back to text field alert controller
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                print("user added: \(userEmailTextField!.text!)")
            }
            
            
            
        }
        
        
        
        alertController.addAction(cancelAction)
        alertController.addAction(addUserAction)
        present(alertController, animated: true, completion: nil)
    }
    
//    @IBAction func logOut(_ sender: Any) {
//        do {
//            try Auth.auth().signOut()
//        }
//        catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
//        }
//
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let initial = storyboard.instantiateInitialViewController()
//        UIApplication.shared.keyWindow?.rootViewController = initial
//    }
    
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
