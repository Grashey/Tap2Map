//
//  AuthCoordinator.swift
//  Tap2Map
//
//  Created by Aleksandr Fetisov on 08.09.2020.
//  Copyright © 2020 Aleksandr Fetisov. All rights reserved.
//

import UIKit

class AuthCoordinator: BaseCoordinator {
    
    var rootController: UINavigationController?
    var onFinishFlow: (() -> Void)?
    
    override func start() {
        showLoginModule()
    }
    
    private func showLoginModule() {
        let controller = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(identifier: LoginViewController.reuseID) as LoginViewController
        controller.onRecover = { [weak self] in
            self?.showRecoverModule()
        }
        
        controller.onLogin = { [weak self] in
            self?.onFinishFlow?()
        }
        
        let rootController = UINavigationController(rootViewController: controller)
        setAsRoot(rootController)
        self.rootController = rootController
    }
    
    private func showRecoverModule() {
        let controller = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(identifier: RegistrationViewController.reuseID) as RegistrationViewController
        rootController?.pushViewController(controller, animated: true)
        
        let coordinator = RegistryCoordinator()
        coordinator.onFinishFlow = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
            self?.start()
        }
        
        addDependency(coordinator)
        coordinator.start()
    }
}
