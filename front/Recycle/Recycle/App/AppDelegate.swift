//
//  AppDelegate.swift
//  Recycle
//
//  Created by Dima Savelyev on 11.03.2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let mapVC = MapViewController()
        mapVC.tabBarItem = UITabBarItem(title: "Карта", image: UIImage(systemName: "map"), tag: 0)
        mapVC.tabBarItem.selectedImage = UIImage(systemName: "map.fill")
        
        let catalogVC = CatalogViewController()
        catalogVC.tabBarItem = UITabBarItem(title: "Каталог", image: UIImage(systemName: "cart"), tag: 1)
        catalogVC.tabBarItem.selectedImage = UIImage(systemName: "cart.fill")
        
        let cameraVC = CameraViewController()
        cameraVC.tabBarItem = UITabBarItem(title: "Сканер", image: UIImage(systemName: "camera"), tag: 1)
        cameraVC.tabBarItem.selectedImage = UIImage(systemName: "camera.fill")
        
        let tabBarController = BubbleTabBarController()
        tabBarController.viewControllers = [catalogVC, cameraVC, mapVC]
        window = UIWindow()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }
}

