//
//  ADPChatController.swift
//  LetsChitChat
//
//  Created by Pritam Hinger on 13/07/17.
//  Copyright © 2017 AppDevelapp. All rights reserved.
//

import UIKit
import Firebase

class ADPChatController: UICollectionViewController {

    let cellId = "cellId"
    
    var user:ChatUser?{
        didSet{
            navigationItem.title = user?.name
            obserMessageForUser()
        }
    }
    
    var messages = [ChatMessage]()
    
    func obserMessageForUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid)
        
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child("messages").child(messageId)
            
            messageRef.observeSingleEvent(of: .value, with: { (messageSnapshot) in
                guard let messageData = messageSnapshot.value as? [String: AnyObject] else{
                    return
                }
                
                let message = ChatMessage()
                message.setValuesForKeys(messageData)
                if message.chatPartnerId() == self.user?.id{
                    self.messages.append(message)
                    
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
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
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
        setUpInputComponents()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func setUpInputComponents() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.white
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
        
        inputTextField.text = nil
    }
}

extension ADPChatController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMesage()
        return true
    }
}

extension ADPChatController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height = CGFloat(80)
        //var width =
        if let text = messages[indexPath.item].text{
            height = estimatedFrame(forText: text).height + 20
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimatedFrame(forText text:String) -> CGRect{
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: (16))], context: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.item]
        cell.textView.text = message.text!
        setUpCell(cell: cell, message: message)
        cell.bubbleWidthAnchor?.constant = estimatedFrame(forText: message.text!).width + 32
        return cell
    }
    
    func setUpCell(cell: ChatMessageCell, message:ChatMessage) {
        if let profileImageURL = self.user?.profileImageURL{
            cell.profileImageView.loadImageFromCache(withUrl: profileImageURL)
        }
        
        if message.fromId == Auth.auth().currentUser?.uid{
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = UIColor.white
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            cell.profileImageView.isHidden = true
        }
        else{
            cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            cell.textView.textColor = UIColor.black
            cell.profileImageView.isHidden = false
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
    }
}
