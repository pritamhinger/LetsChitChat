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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name!
        cell.detailTextLabel?.text = user.email!
        return cell
    }
}


class NewMessageCell : UITableViewCell{
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
}
