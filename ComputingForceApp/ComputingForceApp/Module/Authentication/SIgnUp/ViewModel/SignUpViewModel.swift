//
//  SignUpViewModel.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/12.
//

import Foundation

class SignUpViewModel: BaseViewModel {
    
    override func getXibName() -> String {
        return "SignUpViewController"
    }
    
    let cellIdentifier = "CommonTextFieldCell"
    
    let dataSource: [SignUpCellModel]
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var company: String = ""
    @Published var phone: String = ""
    
    override init() {
        let signUpDataSource = SignUpDataSource()
        dataSource = signUpDataSource.models
        super.init()
    }
}
