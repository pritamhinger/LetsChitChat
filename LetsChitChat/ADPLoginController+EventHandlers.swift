//
//  ADPLoginController+EventHandlers.swift
//  LetsChitChat
//
//  Created by Pritam Hinger on 11/07/17.
//  Copyright © 2017 AppDevelapp. All rights reserved.
//

import UIKit
import Firebase

extension ADPLoginController{
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
            
            self.messageControllerVC?.fetchUserAndSetUserDetailsOnUI()
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
            
            let storageRef = Storage.storage().reference().child("\(uid).jpg")
            if let profileImage = self.applicationLogoImageView.image, let imageData = UIImageJPEGRepresentation(profileImage, 0.1){
                storageRef.putData(imageData, metadata: nil, completion: { (metadata, storageError) in
                    if storageError != nil{
                        print(storageError!)
                        return
                    }
                    
                    if let profileURL = metadata?.downloadURL()?.absoluteString{
                        let userProfileData = ["name": name, "email": email, "profileImageURL": profileURL]
                        self.addUserProfileInfoIntoDB(withUID: uid, userData: userProfileData)
                        print(metadata!)
                    }
                })
            }
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
    
    func addUserProfileInfoIntoDB(withUID uid:String, userData: [String: String])   {
        let ref = Database.database().reference()
        let childRef = ref.child("users").child(uid)
        //let userData = ["name": name, "email": email]
        childRef.updateChildValues(userData, withCompletionBlock: { (err, ref) in
            if err != nil{
                print(err!)
                return
            }
            
            print("User successfully saved")
            let user = ChatUser()
            user.setValuesForKeys(userData)
            self.messageControllerVC?.setUpNavBar(withUser: user)
            self.dismiss(animated: true, completion: nil)
        })
    }
}

extension ADPLoginController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func handleSelectProfileImage() {
        let pickerVC = UIImagePickerController()
        pickerVC.delegate = self
        pickerVC.allowsEditing = true
        present(pickerVC, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil )
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        var selectedImageFromPicker:UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        }else if let selectedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            print(selectedImage.size)
            selectedImageFromPicker = selectedImage
        }
        
        if let newImage = selectedImageFromPicker{
            applicationLogoImageView.image = newImage
        }
        
        dismiss(animated: true, completion: nil )
    }
}
