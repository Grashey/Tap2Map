//
//  MainCoordinator.swift
//  Tap2Map
//
//  Created by Aleksandr Fetisov on 08.09.2020.
//  Copyright © 2020 Aleksandr Fetisov. All rights reserved.
//

import UIKit

class MainCoordinator: BaseCoordinator {
    
    var rootController: UINavigationController?
    var onFinishFlow: (() -> Void)?
    
    override func start() {
        showMainModule()
    }
    
    private func showMainModule() {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: MainViewController.reuseID) as MainViewController
        controller.onMap = { [weak self] in
            self?.showMapModule()
        }
        
        controller.onLogout = { [weak self] in
            self?.onFinishFlow?()
        }
        
        let rootController = UINavigationController(rootViewController: controller)
        setAsRoot(rootController)
        self.rootController = rootController
    }
    
    private func showMapModule() {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: MapViewController.reuseID) as MapViewController
        rootController?.pushViewController(controller, animated: true)
    }
}
