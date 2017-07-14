//
//  ADPChatController.swift
//  LetsChitChat
//
//  Created by Pritam Hinger on 13/07/17.
//  Copyright © 2017 AppDevelapp. All rights reserved.
//

import UIKit
import Firebase

class ADPChatController: UICollectionViewController, UITextFieldDelegate {

    var user:ChatUser?{
        didSet{
            navigationItem.title = user?.name
        }
    }
    
    lazy var inputTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message to send..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.white
        setUpInputComponents()
    }
    
    func setUpInputComponents() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(sendMesage), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        containerView.addSubview(inputTextField)
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorView)
        
        separatorView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        separatorView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    func sendMesage() {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let userId = user!.id!
        let fromUserId = Auth.auth().currentUser!.uid
        let timestamp: NSNumber = NSNumber(integerLiteral: Int(NSDate().timeIntervalSince1970))
        let values = ["text" : inputTextField.text!, "toId": userId, "fromId" : fromUserId, "timestamp": timestamp] as [String : Any]
        //childRef.updateChildValues(values)
        childRef.updateChildValues(values, withCompletionBlock: { (error,  ref) in
            if error != nil{
                print(error!)
                return
            }
            
            let userMessageRef = Database.database().reference().child("user-messages").child(fromUserId)
            
            let messageId = childRef.key
            userMessageRef.updateChildValues([messageId: 1])
            
            let recepientUserMessageRef = Database.database().reference().child("user-messages").child(userId)
            recepientUserMessageRef.updateChildValues([messageId: 1])
        })
        inputTextField.text = ""
    }
}

extension ADPChatController{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMesage()
        return true
    }
}
