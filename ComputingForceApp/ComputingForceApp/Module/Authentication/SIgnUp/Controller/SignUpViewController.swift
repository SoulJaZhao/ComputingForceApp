//
//  SignUpViewController.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/12.
//

import UIKit

class SignUpViewController: BaseViewController<SignUpViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        self.title = Localization.text(key: "SignUp")
    }
}
