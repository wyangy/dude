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
    let senderID : String
    let message : String
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
    
    @IBOutlet weak var senderProfilePic: UIImageView!
    
    @IBOutlet weak var message: UILabel!
    
    
    
    
    @IBOutlet weak var chatLog: UITableView!
    
    var chat = [String]()
    
    @IBAction func swipeUp(_ sender: UISwipeGestureRecognizer) {
        print("Swiped Up")
        chat += ["🍺"]
        chatLog.reloadData()
        
        saveMessage(message: "🍺")
    }
    
    @IBAction func swipeDown(_ sender: UISwipeGestureRecognizer) {
        print("Swiped Down")
        chat += ["💩"]
        chatLog.reloadData()
    }
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        print("Swiped Left")
        chat += ["🍕"]
        chatLog.reloadData()
    }
    
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        print("Swiped Right")
        chat += ["👊"]
        chatLog.reloadData()
    }
    
    @IBAction func dude(_ sender: UILongPressGestureRecognizer) {
        chat += ["DUDE!!!"]
        chatLog.reloadData()
    }
    
    
    
    
    func saveMessage(message: String) {
        
        databaseRef.child("posts").childByAutoId().setValue([
            "senderID": Auth.auth().currentUser!.uid,
            "message": message,
            ]) { (error:Error?, databaseRef:DatabaseReference) in
            if let error = error {
                print("Message could not be saved: \(error.localizedDescription)")
                
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                print("Message saved successfully for senderID: \(Auth.auth().currentUser!.uid), message: \(message)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = chat[indexPath.row]
        cell.detailTextLabel?.text = "userID"
        cell.imageView?.image = UIImage(named: "tiki.jpg")
        
        //        var profileImage = cell.viewWithTag(1) as! UIImageView
        //        var messageText = cell.viewWithTag(2) as! UILabel
        //        messageText.text = chat[indexPath.row]
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
