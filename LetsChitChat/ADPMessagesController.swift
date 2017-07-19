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

    let cellId = "cellId"
    
    var ref: DatabaseReference!
    var messages = [ChatMessage]()
    var messageDictionary = [String : ChatMessage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleNewMessage))
        
        checkIfUserIsLoggedIn()
        
        tableView.register(NewMessageCell.self, forCellReuseIdentifier: cellId)
    }
    
    func observeUserMessage() {
        guard let uId = Auth.auth().currentUser?.uid else{
            print("Invalid User");
            return
        }
        
        let ref = Database.database().reference().child("user-messages").child(uId)
        ref.observe(.childAdded, with: { (snapshot) in
            let userId = snapshot.key
            Database.database().reference().child("user-messages").child(uId).child(userId).observe(.childAdded, with: { (snapshot) in
                let messageId = snapshot.key
                self.fetchMessages(withMessageId: messageId)
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    var timer:Timer?
    
    func handleReloadTable() {
        self.messages = Array(self.messageDictionary.values)
        self.messages.sort(by: { (message1, message2) -> Bool in
            return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
        })
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func fetchMessages(withMessageId messageId: String) {
        let messageRef = Database.database().reference().child("messages").child(messageId)
        messageRef.observe(.value, with: { (messageSnapshot) in
            
            if let chatData = messageSnapshot.value as? [String: AnyObject]{
                
                let message = ChatMessage(dictionary: chatData)
                
                if let chatPartnerId = message.chatPartnerId(){
                    self.messageDictionary[chatPartnerId] = message
                }
                
                self.attemptToReloadTable()
            }
        }, withCancel: nil)
    }
    
    private func attemptToReloadTable() {
        
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
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
        newMessageController.messagesController = self
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
                //self.navigationItem.title = data["name"] as? String
                
                let chatUser = ChatUser()
                chatUser.setValuesForKeys(data)
                self.setUpNavBar(withUser: chatUser)
            }
        }, withCancel: nil)
    }
    
    func setUpNavBar(withUser user: ChatUser)  {
        messages.removeAll()
        messageDictionary.removeAll()
        tableView.reloadData()
        observeUserMessage()
        self.navigationItem.title = user.name
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        titleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        
        if let profileImageURL = user.profileImageURL{
            profileImageView.loadImageFromCache(withUrl: profileImageURL)
        }
        
        containerView.addSubview(profileImageView)
        
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let usernameLabel = UILabel()
        
        usernameLabel.text = user.name!
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(usernameLabel)
        
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        usernameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
    }
    
    func showChatController(withUser user:ChatUser) {
        let chatController = ADPChatController(collectionViewLayout: UICollectionViewFlowLayout())
        chatController.user = user
        navigationController?.pushViewController(chatController, animated: true)
    }
}

extension ADPMessagesController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NewMessageCell
        
        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        guard let chatPartnerId = message.chatPartnerId() else {
            print("Failed to ge chat partner id")
            return
        }
        
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userData = snapshot.value as? [String : AnyObject] else{
                return
            }
            
            let user = ChatUser()
            user.id = chatPartnerId
            user.setValuesForKeys(userData)
            self.showChatController(withUser: user)
        }, withCancel: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}

