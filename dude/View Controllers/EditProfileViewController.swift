//
//  EditProfileViewController.swift
//  dude
//
//  Created by Wendy Yang on 2019/11/12.
//  Copyright © 2019 wyangy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var photo: UIImageView!
    
    @IBAction func edit(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take photo", style: .default, handler: { (action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        
        alert.addAction(UIAlertAction(title: "Choose photo", style: .default, handler: {(action: UIAlertAction) in
            
            self.getImage(fromSourceType: .photoLibrary)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {

        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            imagePicker.delegate = self
            imagePicker.sourceType = sourceType
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        photo.image = info[.originalImage] as? UIImage
        imagePicker.dismiss(animated: true, completion: nil)
        uploadPhotoToStorage()
        print("finished picking")
    } // error appears after this function is called: [discovery] errors encountered while discovering extensions: Error Domain=PlugInKit Code=13 "query cancelled" UserInfo={NSLocalizedDescription=query cancelled
    
    func uploadPhotoToStorage() {
        let data = photo.image!.jpegData(compressionQuality: 0.1)!
        
        let imagesRef = Storage.storage().reference().child("profilePics/" + "\(String(describing: Auth.auth().currentUser!.email))")
        print("Current user email ID: \(String(describing: Auth.auth().currentUser!.email!))")
        
        imagesRef.putData(data, metadata: nil) { (metadata, error) in
            if error == nil {
                print("User profile pic saved at \((metadata!.downloadURL())!)")
                
                self.saveUsersInfo(email: Auth.auth().currentUser!.email!, profilePicUrl: metadata!.downloadURL()!.absoluteString)
                
                senderDictionary[Auth.auth().currentUser!.email!] = UIImage(data: data)
            } else {
                self.showAlert(title: "Error", message: error!.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if senderDictionary[Auth.auth().currentUser!.email!] != UIImage(named: "buzzybee.jpg") {
            self.photo.image = senderDictionary[Auth.auth().currentUser!.email!]
        }
    }
    
}
