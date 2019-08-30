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
import FirebaseStorage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var photo: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    @IBAction func selectPhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("select photo")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        photo.image = info[.originalImage] as? UIImage
        imagePicker.dismiss(animated: true, completion: nil)
        print("finished picking")
    } // error appears after this function is called: [discovery] errors encountered while discovering extensions: Error Domain=PlugInKit Code=13 "query cancelled" UserInfo={NSLocalizedDescription=query cancelled
    
    
    func uploadPhotoToStorage() {
       
            let data = photo.image!.jpegData(compressionQuality: 0.1)!
            
//            let imagesRef = Storage.storage().reference().child("profilePics/" + "\(Auth.auth().currentUser!.uid)")
//            print("Current user uid: \(Auth.auth().currentUser!.uid)")
        
        let imagesRef = Storage.storage().reference().child("profilePics/" + "\(String(describing: Auth.auth().currentUser!.email))")
        print("Current user email ID: \(String(describing: Auth.auth().currentUser!.email!))")
        
            imagesRef.putData(data, metadata: nil) { (metadata, error) in
                if error == nil {
                    print("User profile pic saved at \((metadata!.downloadURL())!)")
                    
//                    self.saveUsersInfo(uid: Auth.auth().currentUser!.uid, email: Auth.auth().currentUser!.email!, profilePicUrl: metadata!.downloadURL()!.absoluteString)
                    
                    self.saveUsersInfo(email: Auth.auth().currentUser!.email!, profilePicUrl: metadata!.downloadURL()!.absoluteString)
                    
                } else {
                    self.showAlert(title: "Error", message: error!.localizedDescription)
                }
            }
    }
    
//    func saveUsersInfo(uid: String, email: String, profilePicUrl: String) {
//        let database = Firestore.firestore()
//
//        database.collection("users").document(uid).setData([
//            "email": email,
//            "profilePicUrl": profilePicUrl,
//        ]) { (error) in
//            if error == nil {
//                print("User profile created for uid: \(uid), email: \(email), profilePicUrl: \(profilePicUrl)")
//                self.performSegue(withIdentifier: "signUpToChatroom", sender: self)
//            } else {
//                self.showAlert(title: "Error", message: error!.localizedDescription)
//            }
//        }
//    }
    
    func saveUsersInfo(email: String, profilePicUrl: String) {
        let database = Firestore.firestore()
        
        database.collection("users").document(email).setData([
//            "email": email,
            "profilePicUrl": profilePicUrl,
        ]) { (error) in
            if error == nil {
                print("User profile created for email: \(email), profilePicUrl: \(profilePicUrl)")
                self.performSegue(withIdentifier: "signUpToChatroom", sender: self)
            } else {
                self.showAlert(title: "Error", message: error!.localizedDescription)
            }
        }
    }
    
    @IBAction func cancel(_ segue: UIStoryboardSegue) {
    }
    
    @IBAction func submit(_ sender: Any) {
        if photo.image != nil {
            uploadPhotoToStorage()
        } else {
            self.showAlert(title: "No image selected", message: "Please select a profile picture.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
