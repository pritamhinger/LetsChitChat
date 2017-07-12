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

class ADPMessagesController: UITableViewController {

    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleNewMessage))
        
        checkIfUserIsLoggedIn()
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil{
            // User not logged in
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        else{
            // User logged in
            fetchUserAndSetUserDetailsOnUI()
        }
    }
    
    func handleNewMessage() {
        let newMessageController = ADPNewMessageController()
        let newMessageNavigationVC = UINavigationController(rootViewController: newMessageController)
        present(newMessageNavigationVC, animated: true, completion: nil)
    }
    
    func handleLogout() {
        
        do{
            try Auth.auth().signOut()
        }
        catch let error{
            print(error)
        }
        
        let loginController = ADPLoginController()
        loginController.messageControllerVC = self
        present(loginController, animated: true, completion: nil)
    }
    
    func fetchUserAndSetUserDetailsOnUI() {
        guard let uid = Auth.auth().currentUser?.uid else{
            print("User not logged in")
            return
        }
        
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let data = snapshot.value as? [String: AnyObject]{
                self.navigationItem.title = data["name"] as? String
            }
        }, withCancel: nil)
    }
}

