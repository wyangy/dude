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
    
    
    @IBOutlet weak var username: UITextField!
    
    func uploadPhotoToStorage() {
       
            let data = photo.image!.jpegData(compressionQuality: 0.1)!
            
            let imagesRef = Storage.storage().reference().child("profilePics/" + "\(Auth.auth().currentUser!.uid)")
            print("Current user uid: \(Auth.auth().currentUser!.uid)")
            
            imagesRef.putData(data, metadata: nil) { (metadata, error) in
                if error == nil {
                    print("User profile pic saved at \((metadata!.downloadURL())!)")
                    
                    self.saveUsersInfo(uid: Auth.auth().currentUser!.uid, email: Auth.auth().currentUser!.email!, profilePicUrl: metadata!.downloadURL()!.absoluteString)
                    
                } else {
                    print("Error: \(error!.localizedDescription)")
                    
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
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
                self.performSegue(withIdentifier: "signUpToChatroom", sender: self)
            } else {
                print("Error creating user profile: \(error!.localizedDescription)")
                
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func submit(_ sender: Any) {
        if photo.image != nil {
            uploadPhotoToStorage()
        } else {
            print("Please select a profile picture.")
            let alertController = UIAlertController(title: "No image selected", message: "Please select a profile picture.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
