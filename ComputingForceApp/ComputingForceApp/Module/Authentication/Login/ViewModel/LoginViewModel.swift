//
//  LoginViewModel.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/12.
//

import Foundation

class LoginViewModel: BaseViewModel {
    
    @Published var isRemeberMe = false
    @Published var username: String = ""
    @Published var password: String = ""
    
    override func getXibName() -> String {
        return "LoginViewController"
    }
}
