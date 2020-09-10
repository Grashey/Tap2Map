//
//  SceneDelegate.swift
//  Tap2Map
//
//  Created by Aleksandr Fetisov on 02.09.2020.
//  Copyright © 2020 Aleksandr Fetisov. All rights reserved.
//

import UIKit
import GoogleMaps

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: ApplicationCoordinator?
    var shieldView: UIImageView?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        GMSServices.provideAPIKey("AIzaSyDjYMAM5gEgmgRUTtT5Duc45AJTIOthRPY")
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        coordinator = ApplicationCoordinator()
        coordinator?.start()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        shieldView?.removeFromSuperview()
        shieldView = nil
    }

    func sceneWillResignActive(_ scene: UIScene) {
        shieldView = UIImageView(frame: self.window!.frame)
        shieldView?.image = UIImage(named: "mickey mouse")
        shieldView?.contentMode = .scaleAspectFit
        self.window?.addSubview(shieldView!)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

