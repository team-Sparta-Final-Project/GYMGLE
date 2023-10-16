//
//  SceneDelegate.swift
//  GYMGLE
//
//  Created by t2023-m0078 on 2023/10/11.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
//        let tabBarController = UITabBarController()
//        
//        let viewController1 = UINavigationController(rootViewController: UserRootViewController())
//        let viewController2 = UINavigationController(rootViewController: InitialViewController())
//        let viewController3 = UINavigationController(rootViewController: UserRootViewController())
//        let viewController4 = UINavigationController(rootViewController: InitialViewController())
//        
//        tabBarController.setViewControllers([viewController1, viewController2, viewController3, viewController4], animated: true)
//        
//        tabBarController.tabBar.backgroundColor = ColorGuide.userBackGround
//        tabBarController.tabBar.tintColor = ColorGuide.white
//        tabBarController.tabBar.layer.shadowColor = ColorGuide.white.cgColor
//        tabBarController.tabBar.layer.shadowOpacity = 0.25
//        tabBarController.tabBar.layer.shadowRadius = 2
//        tabBarController.tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
//        
//        if let items = tabBarController.tabBar.items {
//            items[0].selectedImage = UIImage(systemName: "house.fill")
//            items[0].image = UIImage(systemName: "house")
//            items[0].title = "홈"
//            
//            items[1].selectedImage = UIImage(systemName: "doc.fill")
//            items[1].image = UIImage(systemName: "doc")
//            items[1].title = "공지사항"
//            
//            items[2].selectedImage = UIImage(systemName: "qrcode")
//            items[2].image = UIImage(systemName: "qrcode")
//            items[2].title = "QR코드"
//            
//            items[3].selectedImage = UIImage(systemName: "person.fill")
//            items[3].image = UIImage(systemName: "person")
//            items[3].title = "마이페이지"
//        }
//    
        
        window = UIWindow(windowScene: windowScene)
        let navi = UINavigationController(rootViewController: InitialViewController())
        window?.rootViewController = navi
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
    }


}

