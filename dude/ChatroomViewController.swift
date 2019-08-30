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
//        let senderID : String //for matching senders
    let senderEmail : String //for display
    let message : String
    //    let profilePicUrl : String
}

struct Sender {
        let senderID : String
//    let senderEmail : String
//    let profilePicUrl : String
    let profileImage : UIImage
}

//var senderProfileImageDict: [String: UIImage] = [:]

class ChatroomViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
//    var session: URLSession!
    
    var posts = [Post]()
    var senders = [Sender]()
    
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
//            let senderID = value?["senderID"] as! String
            let senderEmail = value?["senderEmail"] as! String
            let message = value?["message"] as! String
            //            let profilePicUrl = self.getUserProfilePic(senderID: Auth.auth().currentUser!.uid)
            //            print("profilePicUrl: \(profilePicUrl)")
            
            
            //            self.posts.append(Post (senderID: senderID, message: message, profilePicUrl: profilePicUrl))
            self.posts.append(Post (senderEmail: senderEmail, message: message))
            //            print(self.posts)
            
            for index in 0..<self.posts.count {
//                if self.senders[index].senderID == "" {
//                    self.getProfileImage(senderID: senderID)
//                }
            }
            
            self.chatLog.reloadData()
            
            let indexPath = NSIndexPath(item: self.posts.count - 1, section: 0)
            self.chatLog.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
            
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
                //                print("Message saved successfully for senderID: \(Auth.auth().currentUser!.uid), message: \(message)")
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
        let profileImage = cell.viewWithTag(3) as! UIImageView
        let currentUsersProfileImage = cell.viewWithTag(4) as! UIImageView
        
        messageText.text = posts[indexPath.row].message
        senderEmail.text = posts[indexPath.row].senderEmail
        
        if posts[indexPath.row].senderEmail == Auth.auth().currentUser!.email! {
            messageText.textAlignment = .right
            senderEmail.textAlignment = .right
            profileImage.image = nil
            currentUsersProfileImage.image = UIImage(named: "buzzyBee.jpg")
        } else {
            messageText.textAlignment = .left
            senderEmail.textAlignment = .left
            currentUsersProfileImage.image = nil
            profileImage.image = UIImage(named: "tiki.jpg")
            
//            if profileImage.image != nil {
//                profileImage.image = UIImage(named: "userImage.jpg")
//            } else {
//                profileImage.image = UIImage(named: "tiki.jpg")
//            }
        }
        
        return cell
    }
    
//    func saveProfileImage(profilePicUrl: String) {
////        senderProfileImageDict["senderEmail"] = UIImage(named: "tiki.jpg")
////        print(senderProfileImageDict)
//
//        session!.dataTask(with: URL(string: profilePicUrl)!) { (data, response, error) in
//            if error == nil {
//                DispatchQueue.main.async {
////                    self.trainer[index].image = UIImage(data: data!)
////                    self.refreshControl.endRefreshing()
//                    senderProfileImageDict[profilePicUrl] = UIImage(named: "tiki.jpg")
//                }
//            } else {
//                self.showAlert(title: "Error", message: error!.localizedDescription)
//            }
//            }.resume()
//    }
    
    func getProfileImage(email: String) {
        
        let firestoreRef = Firestore.firestore().collection("users").document(senderID)
        
        firestoreRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
//                let url = (document.data()["profilePicUrl"])! as! String
                let url = document.data()["profilePicUrl"] as! URL
//                print("User profile pic url retrieved \(url)")
                
//                self.saveProfileImage(profilePicUrl: url)
                
                    URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if error == nil {
                        DispatchQueue.main.async {
                            //                    self.trainer[index].image = UIImage(data: data!)
                            //                    self.refreshControl.endRefreshing()
//                            senderProfileImageDict[profilePicUrl] = UIImage(named: "tiki.jpg")
                            
                            //save profile image to sender struct
//                            self.trainer[index].image = UIImage(data: data!)
                            
//                            self.senders.append(Sender (senderID: senderID, profileImage: UIImage(data: data!)!))
                            
                            self.sendersDictionary[senderID] = UIImage(data: data!)
                            
//                            stringsAsInts["three"] = 3
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
        
//        saveSenderProfileImageToDict()
    }
    
    
    /*
     // MARK: - Get Profile Images
          
     struct Sender {
     let UID : String
     let Email : String
     let profilePicUrl : String
     var profileImage: UIImage?
     }
     
     */
    
    
}
