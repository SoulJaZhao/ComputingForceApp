//
//  BaseTabBarController.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/4.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    let viewModel: BaseTabBarViewModel
    
    init(viewModel: BaseTabBarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = viewModel.getViewControllers()
    }
}
