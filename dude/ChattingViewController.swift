//
//  ChattingViewController.swift
//  dude
//
//  Created by Wendy Yang on 2019/3/6.
//  Copyright © 2019 wyangy. All rights reserved.
//

import UIKit

class ChattingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var chatLog: UITableView!
    
    var chat = [String]()
    
    @IBAction func chatDude(_ sender: Any) {
        chat += ["dude"]
        chatLog.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create an object of the dynamic cell "PlainCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = chat[indexPath.row]
        
        return cell
        
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
