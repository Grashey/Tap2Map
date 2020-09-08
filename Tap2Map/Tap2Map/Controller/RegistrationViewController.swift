//
//  RegistrationViewController.swift
//  Tap2Map
//
//  Created by Aleksandr Fetisov on 07.09.2020.
//  Copyright © 2020 Aleksandr Fetisov. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGR.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGR)
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
    }
    
    @objc private func hideKeyboard(){
           view.endEditing(true)
       }
}
