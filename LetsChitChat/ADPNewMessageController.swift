//
//  ADPNewMessageController.swift
//  LetsChitChat
//
//  Created by Pritam Hinger on 10/07/17.
//  Copyright © 2017 AppDevelapp. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ADPNewMessageController: UITableViewController {

    let cellReuseIdentifier = "newMessageCell"
    var ref: DatabaseReference!
    var messagesController:ADPMessagesController?
    
    var users = [ChatUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancelVC))
        tableView.register(NewMessageCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        ref = Database.database().reference()
        fetchUsers()
    }

    func fetchUsers() {
        ref.child("users").observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            if let data = snapshot.value as? [String: AnyObject]{
                let user = ChatUser()
                user.id = snapshot.key
                user.setValuesForKeys(data)
                print("User Data: Name : \(String(describing: user.name)) and Email: \(String(describing: user.email))")
                self.users.append(user)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }, withCancel: nil)
    }
    
    func handleCancelVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! NewMessageCell
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name!
        cell.detailTextLabel?.text = user.email!
        
        
        if let profileImageUrl = user.profileImageURL{
            cell.profileImageView.loadImageFromCache(withUrl: profileImageUrl)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: {
            print("Dismiss Completed")
            let user = self.users[indexPath.row]
            self.messagesController?.showChatController(withUser: user)
        })
    }
}


class NewMessageCell : UITableViewCell{
    
    let profileImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "chitchat_logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
}
