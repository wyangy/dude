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
    let email : String
    let message : String
}

var senderDictionary: [String : UIImage] = [:]

class ChatroomViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var posts = [Post]()
    
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
            let email = value?["email"] as! String
            let message = value?["message"] as! String
            
            self.posts.append(Post (email: email, message: message))
//            print(self.posts)
            
                self.getProfileImage(email: email)
            
            DispatchQueue.main.async {
                self.chatLog.reloadData()
                let indexPath = NSIndexPath(item: self.posts.count - 1, section: 0)
                self.chatLog.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
            }
            
        }) { (error) in
            self.showAlert(title: "Message could not be loaded", message: error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let messageText = cell.viewWithTag(1) as! UILabel
        let email = cell.viewWithTag(2) as! UILabel
        let senderImage = cell.viewWithTag(3) as! UIImageView
        let currentUserImage = cell.viewWithTag(4) as! UIImageView
        
        messageText.text = posts[indexPath.row].message
        email.text = posts[indexPath.row].email
        
        if posts[indexPath.row].email == Auth.auth().currentUser!.email! {
            messageText.textAlignment = .right
            email.textAlignment = .right
            senderImage.image = nil
            
            if let displayImage = senderDictionary[posts[indexPath.row].email] {
                currentUserImage.image = displayImage
            } else {
                currentUserImage.image = UIImage(named: "buzzyBee.jpg")
            }
            
        } else {
            messageText.textAlignment = .left
            email.textAlignment = .left
            currentUserImage.image = nil
            
            if let displayImage = senderDictionary[posts[indexPath.row].email] {
                senderImage.image = displayImage
            } else {
                senderImage.image = UIImage(named: "tiki.jpg")
            }
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
                        
                        if senderDictionary[email] == nil {
                            senderDictionary[email] = UIImage(data: data!)
                            print("Profile image downloaded for \(email)")
//                            print(senderDictionary)
                        }

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
        self.chatLog.rowHeight = 90
        
        loadMessage()
    }
    
}
