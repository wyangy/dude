//
//  showAlert.swift
//  dude
//
//  Created by Wendy Yang on 2019/8/30.
//  Copyright © 2019 wyangy. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
//    func displayError(errorMessage: String) {
//        print("Error: \(errorMessage)")
//
//        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
//        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//
//        alertController.addAction(defaultAction)
//        self.present(alertController, animated: true, completion: nil)
//    }
    
    func showAlert(title: String, message: String) {
        print("\(title): \(message)")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
