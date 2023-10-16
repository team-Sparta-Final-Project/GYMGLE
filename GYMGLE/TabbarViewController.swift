//
//  TabbarViewController.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/16.
//

import UIKit

final class TabbarViewController: UITabBarController {
    enum TabBarMenu: Int {
        case userRootVC = 0
        case initialVC
        case userRootVC2
        case initialVC2
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTabControllers()
        self.delegate = self
    }
    
    func setTabControllers() {
        let userRootVC = UserRootViewController()
        let naviUserRootVC = UINavigationController(rootViewController: userRootVC)
        
        let initialVC = InitialViewController()
        let naviInitialVC = UINavigationController(rootViewController: initialVC)
        
        let userRootVC2 = UserRootViewController()
        let naviUserRootVC2 = UINavigationController(rootViewController: userRootVC2)
        
        let initialVC2 = InitialViewController()
        let naviInitialVC2 = UINavigationController(rootViewController: initialVC2)
        
        let controllers = [naviUserRootVC, naviInitialVC, naviUserRootVC2, naviInitialVC2]
        self.viewControllers = controllers
        
        self.tabBar.layer.borderWidth = 1
        self.tabBar.layer.borderColor = UIColor.white.cgColor
        
        self.tabBar.tintColor = ColorGuide.main //탭바 아이템 색
        
        
        self.tabBar.items![0].imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        self.tabBar.items![0].image = UIImage(systemName: "house")?.withRenderingMode(.alwaysOriginal).withTintColor(ColorGuide.textHint)
        self.tabBar.items![0].selectedImage = UIImage(systemName: "house.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(ColorGuide.main)
        self.tabBar.items![0].title = "홈"
        
        
        self.tabBar.items![1].imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        self.tabBar.items![1].image = UIImage(systemName: "doc")?.withRenderingMode(.alwaysOriginal).withTintColor(ColorGuide.textHint)
        self.tabBar.items![1].selectedImage = UIImage(systemName: "doc.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(ColorGuide.main)
        self.tabBar.items![1].title = "공지사항"
        
       
        self.tabBar.items![2].imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        self.tabBar.items![2].image = UIImage(systemName: "qrcode")?.withRenderingMode(.alwaysOriginal).withTintColor(ColorGuide.textHint)
        self.tabBar.items![2].selectedImage = UIImage(systemName: "qrcode")?.withRenderingMode(.alwaysOriginal).withTintColor(ColorGuide.main)
        self.tabBar.items![2].title = "QR코드"
        
       
        self.tabBar.items![3].imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        self.tabBar.items![3].image = UIImage(systemName: "person.crop.circle")?.withRenderingMode(.alwaysOriginal).withTintColor(ColorGuide.textHint)
        self.tabBar.items![3].selectedImage = UIImage(systemName: "person.crop.circle.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(ColorGuide.main) // 이미지의 색을 정한 색으로 나오게 하기 위해..
        self.tabBar.items![3].title = "마이페이지"
    }
}

extension TabbarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 0 {
        }
        print("tabBarIndex : \(tabBarIndex)")
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            
            return false
        }
        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        }
        return true
    }
}
