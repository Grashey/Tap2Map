//
//  RegistrationViewController.swift
//  Tap2Map
//
//  Created by Aleksandr Fetisov on 07.09.2020.
//  Copyright © 2020 Aleksandr Fetisov. All rights reserved.
//

import UIKit
import RealmSwift

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var onLogin: (() -> Void)?
    var onMain: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        configureNavigationBar()
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGR.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGR)
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        let user = User()
        if let login = loginTextField.text, let password = passwordTextField.text {
            user.login = login
            user.password = password
        }
        do {
            let realm = try Realm()
            let object = realm.objects(User.self).filter("login == [cd] %@", user.login).first
            if user.login == object?.login {
                realm.beginWrite()
                realm.add(user, update: .modified)
                try realm.commitWrite()
                existedUserAlert(name: user.login, new: false)
            } else {
                realm.beginWrite()
                realm.add(user)
                try realm.commitWrite()
                existedUserAlert(name: user.login, new: true)
                
                 let configuration: Realm.Configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
                print(configuration.fileURL ?? "")
            }
        } catch {
            print(error)
        }
    }
    
    func existedUserAlert(name: String, new: Bool) {
        var alert = UIAlertController()
        if new {
            alert = UIAlertController(title: "Registration succesfull", message: "User named \(name) is registered", preferredStyle: .alert)
        } else {
            alert = UIAlertController(title: "User \(name) already exists", message: "User password updated", preferredStyle: .alert)
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            UserDefaults.standard.set(true, forKey: "isLogin")
            self.onMain?()
        }))
        self.present(alert, animated: true)
    }
    
    func configureNavigationBar() {
        let backButton = UIBarButtonItem(title: "< Back", style: .done, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func goBack() {
        self.onLogin?()
    }
    
    @objc private func hideKeyboard(){
           view.endEditing(true)
       }
}
