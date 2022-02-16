//
//  RegisterViewController.swift
//  AppMessage
//
//  Created by Chondro Satrio Wibowo on 12/02/22.
//

import UIKit
import PhotosUI
import AVKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    private let scrollView:UIScrollView = {
       let scrollview = UIScrollView()
        scrollview.clipsToBounds = true
        return scrollview
    }()
    private let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "UploadPicture")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    private let fullnameField:UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Fullname"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 6, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    private let emailField:UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Email Address"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 6, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let passwordField:UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Password"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 6, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        return field
    }()
    
    private let registerButton:UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .green
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20,weight:.bold)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register Page"
        view.backgroundColor = .white
        
        
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(fullnameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(registerButton)
        fullnameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        imageView.isUserInteractionEnabled = true
        
        let gestureImage = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        
        imageView.addGestureRecognizer(gestureImage)
        
        registerButton.addTarget(self, action: #selector(registerButtonTap), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width/3
        
        imageView.frame = CGRect(x: (view.width - size)/2, y: 60, width: size, height: size)
        imageView.layer.cornerRadius = imageView.width / 2.0
        fullnameField.frame = CGRect(x: 24, y: imageView.bottom + 10, width: scrollView.width - 48, height: 52)
        emailField.frame = CGRect(x: 24, y: fullnameField.bottom + 10, width: scrollView.width - 48, height: 52)
        passwordField.frame = CGRect(x: 24, y: emailField.bottom + 10, width: scrollView.width - 48, height: 52)
        registerButton.frame = CGRect(x: 24, y: passwordField.bottom + 24, width: scrollView.width - 48, height: 52)
    }
    
    @objc private func didTapChangeProfilePic(){
        presentPhotoActionSheet()
    }
    
    @objc private func registerButtonTap(){
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        fullnameField.resignFirstResponder()
        let firebaseAuth = FirebaseAuthManager()
        let databaseManager = DatabaseManager()
        guard let fullname = fullnameField.text,let email = emailField.text, let password = passwordField.text,
              !fullname.isEmpty,!email.isEmpty,!password.isEmpty,password.count >= 6 else{
                  alertUserRegisterError()
                  return
              }
       
        firebaseAuth.createAccountWith(email: email, password: password, completion: { (isRegistered,message) in
            if isRegistered == true{
                
                let vc = TabBarViewController()
                databaseManager.register(data: ChatAppUser(fullname: fullname, emailAddress: email, password: password, profilePictureUrl: ""))
                self.navigationController?.navigationItem.hidesBackButton = true
                self.navigationController?.navigationBar.isHidden = true
                self.navigationController?.pushViewController(vc, animated: false)
                
                
            }else{
                self.alertCreateUser(message)
            }
            
        })
        
        
    }
    
    func alertCreateUser(_ message:String){
        let alert = UIAlertController(title: "User account", message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dissmiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func alertUserRegisterError(){
        let alert = UIAlertController(title: "Woops", message: "Please enter all information to create account", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dissmiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @objc private func didTapRegister(){
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    

}
//TextFieldStep
extension RegisterViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField{
            passwordField.becomeFirstResponder()
        }else if textField == passwordField{
            registerButtonTap()
        }
        return true
    }
}
// Image Picker
extension RegisterViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take a photo", style: .default, handler: {[weak self] _ in
            self?.presentCamera()
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose photo", style: .default, handler: {[weak self] _ in
            self?.presentPhotoPicker()
            
        }))
        
        present(actionSheet, animated: true)
    }
    func presentCamera(){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    func presentPhotoPicker(){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        self.imageView.image = selectedImage
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
