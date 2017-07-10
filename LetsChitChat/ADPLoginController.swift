//
//  ADPLoginController.swift
//  LetsChitChat
//
//  Created by Pritam Hinger on 09/07/17.
//  Copyright © 2017 AppDevelapp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ADPLoginController: UIViewController {
    
    let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }() 
    
    lazy var loginButton:UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    
    let nameTextField:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let nameSeparatorView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email address"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let emailSeparatorView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let applicationLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "chitchat_logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var loginRegisterSegmentedControl:UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Login", "Register"])
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.tintColor = UIColor.white
        segmentControl.selectedSegmentIndex = 1
        segmentControl.addTarget(self, action: #selector(handleLoginRegisterSegmentChanged), for: .valueChanged)
        return segmentControl
    }()
    
    var containerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        view.addSubview(containerView)
        view.addSubview(loginButton)
        view.addSubview(applicationLogoImageView)
        view.addSubview(loginRegisterSegmentedControl)
        
        setUpContainer()
        setUpLoginRegisterButton()
        setUpApplicationLogoImage()
        setUpLoginRegisterSegmentedControl()
    }
    
    func setUpContainer() {
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        containerViewHeightAnchor = containerView.heightAnchor.constraint(equalToConstant: 150)
        containerViewHeightAnchor?.isActive = true
        
        containerView.addSubview(nameTextField)
        containerView.addSubview(nameSeparatorView)
        containerView.addSubview(emailTextField)
        containerView.addSubview(emailSeparatorView)
        containerView.addSubview(passwordTextField)
        
        nameTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        nameSeparatorView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        emailTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameSeparatorView.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        emailSeparatorView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        passwordTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    func setUpLoginRegisterButton() {
        loginButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 12).isActive = true
        loginButton.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setUpApplicationLogoImage() {
        applicationLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        applicationLogoImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -12).isActive = true
        applicationLogoImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        applicationLogoImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func setUpLoginRegisterSegmentedControl() {
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0{
            handleLogin()
        }else{
            handleRegister()
        }
    }
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Invalid Credentials")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil{
                print(error!)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else{
            print("Invalid Email or password")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user: User?, error: Error?) -> Void in
            if error != nil{
                print(error!)
                return
            }
            
            print("User successfully created")
            
            guard let uid = user?.uid else{
                return
            }
            
            let ref = Database.database().reference()
            let childRef = ref.child("users").child(uid)
            let userData = ["name": name, "email": email]
            childRef.updateChildValues(userData, withCompletionBlock: { (err, ref) in
                if err != nil{
                    print(err!)
                    return
                }
                
                print("User successfully saved")
                self.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    func handleLoginRegisterSegmentChanged() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginButton.setTitle(title, for: .normal)
        
        containerViewHeightAnchor?.constant = (loginRegisterSegmentedControl.selectedSegmentIndex == 0) ? 100 : 150
        
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: (loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3))
        nameTextFieldHeightAnchor?.isActive = true
        nameTextField.placeholder = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? "" : "Name"
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: (loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3))
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: (loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3))
        passwordTextFieldHeightAnchor?.isActive = true
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}
