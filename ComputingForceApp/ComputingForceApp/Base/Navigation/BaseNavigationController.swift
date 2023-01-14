//
//  BaseNavigationController.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/5.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.modalPresentationStyle = .fullScreen
        self.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let theme = AppContext.context.theme
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = theme.navigationBarColor
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : theme.blackColor]
        
        navigationBar.tintColor = theme.blackColor
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
}
