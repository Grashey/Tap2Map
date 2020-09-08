//
//  MainViewController.swift
//  Tap2Map
//
//  Created by Aleksandr Fetisov on 07.09.2020.
//  Copyright © 2020 Aleksandr Fetisov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var onMap: (() -> Void)?
    var onLogout: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func showMapPressed(_ sender: UIButton) {
        onMap?()
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "isLogin")
        onLogout?()
    }
}
