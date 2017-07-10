//
//  ViewController.swift
//  LetsChitChat
//
//  Created by Pritam Hinger on 09/07/17.
//  Copyright © 2017 AppDevelapp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UITableViewController {

    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        if Auth.auth().currentUser?.uid == nil{
            // User not logged in
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        else{
            // User logged in
        }
    }
    
    func handleLogout() {
        
        do{
            try Auth.auth().signOut()
        }
        catch let error{
            print(error)
        }
        
        let loginController = ADPLoginController()
        present(loginController, animated: true, completion: nil)
    }
}

