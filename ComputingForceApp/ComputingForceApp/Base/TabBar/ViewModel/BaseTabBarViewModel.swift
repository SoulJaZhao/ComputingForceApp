//
//  BaseTabBarViewModel.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/5.
//

import UIKit

class BaseTabBarViewModel {
    
    enum NavigationType {
        case home
        case me
    }
    
    let navigationControllers: [NavigationType] = [.home, .me]
    
    func getViewControllers() -> [UIViewController] {
        return navigationControllers.compactMap { [weak self] type in
            self?.createNavigation(type:type)
        }
    }
    
    func createNavigation(type: NavigationType) -> BaseNavigationController {
        switch type {
        case .me:
            let vc = UIViewController()
            vc.view.backgroundColor = .red
            let navigationController = BaseNavigationController(rootViewController: vc)
            return navigationController
        case .home:
            let vc = UIViewController()
            vc.view.backgroundColor = .blue
            let navigationController = BaseNavigationController(rootViewController: vc)
            return navigationController
        }
    }
}
