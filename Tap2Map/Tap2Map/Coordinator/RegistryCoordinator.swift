//
//  RegistryCoordinator.swift
//  Tap2Map
//
//  Created by Aleksandr Fetisov on 08.09.2020.
//  Copyright © 2020 Aleksandr Fetisov. All rights reserved.
//

import UIKit

class RegistryCoordinator: BaseCoordinator {
    
        var rootController: UINavigationController?
        var onFinishFlow: (() -> Void)?
        
        override func start() {
            showLoginModule()
        }
        
        private func showLoginModule() {
            let controller = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(identifier: RegistrationViewController.reuseID) as RegistrationViewController
            
            controller.onLogin = { [weak self] in
                self?.onFinishFlow?()
            }
            
            let rootController = UINavigationController(rootViewController: controller)
            setAsRoot(rootController)
            self.rootController = rootController
        }
    }

