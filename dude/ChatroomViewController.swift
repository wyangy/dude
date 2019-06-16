//
//  ChatroomViewController.swift
//  dude
//
//  Created by Wendy Yang on 2019/3/6.
//  Copyright © 2019 wyangy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

struct Post {
    //    let senderID : String
    let senderEmail : String
    let message : String
    //    let profilePicUrl : String
}

class ChatroomViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var posts = [Post]()
    
    let databaseRef = Database.database().reference()
    
    @IBAction func logOut(_ sender: Any) {
        do {
            print("\(Auth.auth().currentUser!.email!) is logging out")
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
    }
    
    @IBOutlet weak var chatLog: UITableView!
    
    
    @IBAction func swipeUp(_ sender: UISwipeGestureRecognizer) {
        print("Swiped Up: 🍺")
        saveMessage(message: "🍺")
    }
    
    @IBAction func swipeDown(_ sender: UISwipeGestureRecognizer) {
        print("Swiped Down: 💩")
        saveMessage(message: "💩")
    }
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        print("Swiped Left: 🍕")
        saveMessage(message: "🍕")
    }
    
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        print("Swiped Right: 👊")
        saveMessage(message: "👊")
    }
    
    @IBAction func dude(_ sender: UILongPressGestureRecognizer) {
        print("Long Tap: DUDE!!!")
        saveMessage(message: "DUDE!!!")
    }
    
    func loadMessage() {
        databaseRef.child("posts").observe(DataEventType.childAdded, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            //            let senderID = value?["senderID"] as! String
            let senderEmail = value?["senderEmail"] as! String
            let message = value?["message"] as! String
            //            let profilePicUrl = self.getUserProfilePic(senderID: Auth.auth().currentUser!.uid)
            //            print("profilePicUrl: \(profilePicUrl)")
            
            
            //            self.posts.append(Post (senderID: senderID, message: message, profilePicUrl: profilePicUrl))
            self.posts.append(Post (senderEmail: senderEmail, message: message))
            //            print(self.posts)
            
            self.chatLog.reloadData()
            
            let indexPath = NSIndexPath(item: self.posts.count - 1, section: 0)
            self.chatLog.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
            
        }) { (error) in
            print("Message could not be loaded: \(error.localizedDescription)")
            
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    func saveMessage(message: String) {
        
        databaseRef.child("posts").child(Date().description).setValue([
            //            "senderID": Auth.auth().currentUser!.uid,
            "senderEmail": Auth.auth().currentUser!.email!,
            "message": message,
        ]) { (error:Error?, databaseRef:DatabaseReference) in
            if let error = error {
                print("Message could not be saved: \(error.localizedDescription)")
                
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                print("Message saved successfully for senderEmail: \(Auth.auth().currentUser!.email!), message: \(message)")
                //                print("Message saved successfully for senderID: \(Auth.auth().currentUser!.uid), message: \(message)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = posts[indexPath.row].message
        cell.detailTextLabel?.text = posts[indexPath.row].senderEmail
        //        cell.detailTextLabel?.text = posts[indexPath.row].senderID
        
        
        //        cell.imageView?.image = UIImage(named: "tiki.jpg")
        
        //        var profileImage = cell.viewWithTag(1) as! UIImageView
        //        var messageText = cell.viewWithTag(2) as! UILabel
        //        messageText.text = posts[indexPath.row].message
        
        return cell
    }
    
    //    func getUserProfilePic(senderID: String) -> String {
    //
    //        var url = ""
    //
    //        let firestoreRef = Firestore.firestore().collection("users").document(senderID)
    //
    //        firestoreRef.getDocument { (document, error) in
    //            if let document = document, document.exists {
    //
    //                url = (document.data()["profilePicUrl"])! as! String
    //                print("User profile pic url retrieved \(url)")
    //
    //            } else {
    //                print("Error retrieving user profile pic URL: \(error!.localizedDescription)")
    //
    //                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
    //                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    //
    //                alertController.addAction(defaultAction)
    //                self.present(alertController, animated: true, completion: nil)
    //            }
    //        }
    //
    //        return url
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMessage()
        
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
