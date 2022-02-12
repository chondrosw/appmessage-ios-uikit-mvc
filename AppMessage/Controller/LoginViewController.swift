//
//  LoginViewController.swift
//  AppMessage
//
//  Created by Chondro Satrio Wibowo on 12/02/22.
//

import UIKit


class LoginViewController: UIViewController {
    
    private let scrollView:UIScrollView = {
       let scrollview = UIScrollView()
        scrollview.clipsToBounds = true
        return scrollview
    }()
    private let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Icon")
        imageView.contentMode = .scaleAspectFit
        return imageView
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
    
    private let loginButton:UIButton = {
        let button = UIButton()
        button.setTitle("Log in", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20,weight:.bold)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login Page"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        emailField.delegate = self
        passwordField.delegate = self
        
       
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width/3
        imageView.frame = CGRect(x: (view.width - size)/2, y: 60, width: size, height: size)
        emailField.frame = CGRect(x: 24, y: imageView.bottom + 10, width: scrollView.width - 48, height: 52)
        passwordField.frame = CGRect(x: 24, y: emailField.bottom + 10, width: scrollView.width - 48, height: 52)
        loginButton.frame = CGRect(x: 24, y: passwordField.bottom + 24, width: scrollView.width - 48, height: 52)
    }
    
   
    
    @objc private func loginButtonTapped(){
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        let firebaseAuth = FirebaseAuthManager()
        guard let email = emailField.text, let password = passwordField.text,
              !email.isEmpty,!password.isEmpty,password.count >= 6 else{
                  alertUserLoginError()
                  return
              }
        
        firebaseAuth.loginAccountWith(email: email, password: password, completion: {(isLoggedIn,message) in
            if isLoggedIn == true{
                self.alertLoginUser("Success Login")
                let vc = ConversationViewController()
                let setData = UserDefaults.standard.set(isLoggedIn, forKey: "logged_in")
                
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                self.alertLoginUser(message)
            }
        })
    }
    
    func alertLoginUser(_ message:String){
        let alert = UIAlertController(title: "User account", message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        present(alert, animated: false)
    }
    
    
    func alertUserLoginError(){
        let alert = UIAlertController(title: "Woops", message: "Please enter all information to Login", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dissmiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @objc private func didTapRegister(){
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField{
            passwordField.becomeFirstResponder()
        }else if textField == passwordField{
            loginButtonTapped()
        }
        return true
    }
}
