//
//  LoginViewController.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/12.
//

import UIKit

class LoginViewController: BaseViewController<LoginViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        self.title = Localization.text(key: "SignIn")
    }
}
