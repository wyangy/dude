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
        
    }
    
    func savePhotoUrlToUsersInfo() {
        
    }
    
    @IBAction func submit(_ sender: Any) {
        
//        let database = Firestore.firestore()
//
//        database.collection("users").document("\(Auth.auth().currentUser!.uid)").setData([
//            "email": "\(Auth.auth().currentUser!.email!)",
//            "username": "\(username.text!)",
//
//        ]) { (error) in
//            if error == nil {
//                print("User profile created: \(Auth.auth().currentUser!.email!), \(database.collection("users").document())")
//
////                self.performSegue(withIdentifier: "signUpToProfile", sender: self)
//            }
//            else{
//                print("Error creating user profile: \(error!.localizedDescription)")
//
//                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
//                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//
//                alertController.addAction(defaultAction)
//                self.present(alertController, animated: true, completion: nil)
//            }
//
//
//        }
        uploadPhotoToStorage()
        savePhotoUrlToUsersInfo()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
