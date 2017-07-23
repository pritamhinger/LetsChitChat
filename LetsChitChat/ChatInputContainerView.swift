//
//  ChatInputContainerView.swift
//  LetsChitChat
//
//  Created by Pritam Hinger on 23/07/17.
//  Copyright © 2017 AppDevelapp. All rights reserved.
//

import UIKit

class ChatInputContainerView: UIView, UITextFieldDelegate{

    var chatLogController: ADPChatController? {
        didSet{
            sendButton.addTarget(chatLogController, action: #selector(ADPChatController.sendMesage), for: .touchUpInside)
            imagePickerButtonImageView.addGestureRecognizer(UITapGestureRecognizer(target: chatLogController, action: #selector(ADPChatController.pickImageToSend)))
        }
    }
    
    lazy var inputTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message to send..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    let sendButton = UIButton(type: .system)
    let imagePickerButtonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "imagePicker")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        addSubview(imagePickerButtonImageView)
        
        imagePickerButtonImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imagePickerButtonImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imagePickerButtonImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        imagePickerButtonImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sendButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        addSubview(self.inputTextField)
        
        self.inputTextField.leftAnchor.constraint(equalTo: imagePickerButtonImageView.rightAnchor, constant: 8).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separatorView)
        
        separatorView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separatorView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        separatorView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder aDecoder: NSCoder) not implemented")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        chatLogController?.sendMesage()
        return true
    }
}
