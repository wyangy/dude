//
//  StartViewController.swift
//  dude
//
//  Created by Wendy Yang on 2019/3/2.
//  Copyright © 2019 wyangy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class StartViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) { // why viewDidAppear instead of viewDidLoad?
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            print("already logged in: \(Auth.auth().currentUser!.email!)")
            // self.performSegue(withIdentifier: "alreadyLoggedIn", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
