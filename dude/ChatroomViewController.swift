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
    let senderEmail : String
    let message : String
}

class ChatroomViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var posts = [Post]()
    var sendersDictionary: [String : UIImage] = [:]
    
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
            let senderEmail = value?["senderEmail"] as! String
            let message = value?["message"] as! String
            
            self.posts.append(Post (senderEmail: senderEmail, message: message))
            //            print(self.posts)
            
            //            for index in 0..<self.posts.count {
            ////                if self.senders[index].senderID == "" {
            ////                    self.getProfileImage(senderID: senderID)
            ////                }
            //            }
            
           
            if self.sendersDictionary[senderEmail] == nil {
                self.getProfileImage(email: senderEmail)
            }
            
            
            
            
            DispatchQueue.main.async {
               
                self.chatLog.reloadData()
                let indexPath = NSIndexPath(item: self.posts.count - 1, section: 0)
                self.chatLog.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
            }
            
            
            
            
        }) { (error) in
            self.showAlert(title: "Message could not be loaded", message: error.localizedDescription)
        }
    }
    
    func saveMessage(message: String) {
        
        databaseRef.child("posts").child(Date().description).setValue([
            //            "senderID": Auth.auth().currentUser!.uid,
            "senderEmail": Auth.auth().currentUser!.email!,
            "message": message,
        ]) { (error:Error?, databaseRef:DatabaseReference) in
            if let error = error {
                self.showAlert(title: "Message could not be saved", message: error.localizedDescription)
            } else {
                print("Message saved successfully for senderEmail: \(Auth.auth().currentUser!.email!), message: \(message)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        //        cell.textLabel?.text = posts[indexPath.row].message
        //        cell.detailTextLabel?.text = posts[indexPath.row].senderEmail
        
        //        cell.imageView?.image = UIImage(named: "tiki.jpg")
        
        let messageText = cell.viewWithTag(1) as! UILabel
        let senderEmail = cell.viewWithTag(2) as! UILabel
        let senderImage = cell.viewWithTag(3) as! UIImageView
        let currentUserImage = cell.viewWithTag(4) as! UIImageView
        
        messageText.text = posts[indexPath.row].message
        senderEmail.text = posts[indexPath.row].senderEmail
        
        if posts[indexPath.row].senderEmail == Auth.auth().currentUser!.email! {
            messageText.textAlignment = .right
            senderEmail.textAlignment = .right
            senderImage.image = nil
            //            currentUsersProfileImage.image = UIImage(named: "buzzyBee.jpg")
            
//            currentUsersProfileImage.image = sendersDictionary[Auth.auth().currentUser!.email!]
            
            if let displayImage = sendersDictionary[posts[indexPath.row].senderEmail] {
                currentUserImage.image = displayImage
            } else {
                currentUserImage.image = UIImage(named: "buzzyBee.jpg")
            }
            
//            if currentUsersProfileImage.image != nil {
//                currentUsersProfileImage.image = sendersDictionary[posts[indexPath.row].senderEmail]
//            } else {
//                currentUsersProfileImage.image = UIImage(named: "buzzyBee.jpg")
//            }
            
        } else {
            messageText.textAlignment = .left
            senderEmail.textAlignment = .left
            currentUserImage.image = nil
//            profileImage.image = UIImage(named: "tiki.jpg")
            
            if let displayImage = sendersDictionary[posts[indexPath.row].senderEmail] {
                senderImage.image = displayImage
            } else {
                senderImage.image = UIImage(named: "tiki.jpg")
            }
            
//            if profileImage.image != nil {
//                profileImage.image = sendersDictionary[posts[indexPath.row].senderEmail]
//            } else {
//                profileImage.image = UIImage(named: "tiki.jpg")
//            }
        }
        
        
        
        return cell
    }
    
    func getProfileImage(email: String) {
        
        let firestoreRef = Firestore.firestore().collection("users").document(email)
        
        firestoreRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                let url = (document.data()["profilePicUrl"])! as! String
                
                URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
                    if error == nil {
                        
                        
                        self.sendersDictionary[email] = UIImage(data: data!)
                        print("Profile image downloaded for \(email)")
                        print(self.sendersDictionary)
                        
//                        if  self.sendersDictionary[email] !=  self.sendersDictionary[email] {
//                            self.sendersDictionary[email] = UIImage(data: data!)
//                        }
                        
                        DispatchQueue.main.async {

                            self.chatLog.reloadData()
                        }
                    } else {
                        self.showAlert(title: "Error", message: error!.localizedDescription)
                    }
                    }.resume()
                
            } else {
                self.showAlert(title: "Error retrieving user profile pic URL", message: error!.localizedDescription)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMessage()
        self.chatLog.rowHeight = 90
    }
    
}
