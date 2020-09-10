//
//  LoginViewController.swift
//  Tap2Map
//
//  Created by Aleksandr Fetisov on 07.09.2020.
//  Copyright © 2020 Aleksandr Fetisov. All rights reserved.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var onLogin: (() -> Void)?
    var onRecover: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGR.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGR)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let user = User()
        if let login = loginTextField.text, let password = passwordTextField.text {
            user.login = login
            user.password = password
        }
        do {
            let realm = try Realm()
            let object = realm.objects(User.self).filter("login == [cd] %@", user.login).first
            if user.login == object?.login {
                if user.password != object?.password {
                    wrongInputAlert(loginExists: true)
                } else {
                    UserDefaults.standard.set(true, forKey: "isLogin")
                    onLogin?()
                }
            } else {
                wrongInputAlert(loginExists: false)
            }
        } catch {
            print(error)
        }
    }
    
    @IBAction func registrationButtonPressed(_ sender: UIButton) {
        onRecover?()
    }
    
    func wrongInputAlert(loginExists: Bool) {
        var alert = UIAlertController()
        if loginExists {
            alert = UIAlertController(title: "Incorrect password", message: "Please check and enter the correct password", preferredStyle: .alert)
        } else {
            alert = UIAlertController(title: "Incorrect login", message: "Please check and enter the correct login or sign up", preferredStyle: .alert)
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @objc private func hideKeyboard(){
           view.endEditing(true)
       }
}
