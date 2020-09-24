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
            self?.toAuth()
        }
        
        controller.onTakePicture = { [weak self] image in
            self?.showSelfieModule(image: image)
        }
        
        let rootController = UINavigationController(rootViewController: controller)
        setAsRoot(rootController)
        self.rootController = rootController
    }
    
    private func showMapModule() {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: MapViewController.reuseID) as MapViewController
        rootController?.pushViewController(controller, animated: true)
    }
    
    private func toAuth() {
        let coordinator = AuthCoordinator()
        coordinator.onFinishFlow = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
            self?.start()
        }
        
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func showSelfieModule(image: UIImage) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: SelfieViewController.reuseID) as SelfieViewController
        controller.image = image
        rootController?.pushViewController(controller, animated: true)
    }
}
