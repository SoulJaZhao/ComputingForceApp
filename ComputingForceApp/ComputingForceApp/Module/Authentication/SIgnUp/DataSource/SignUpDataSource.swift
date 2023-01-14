//
//  SignUpDataSource.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/14.
//

import Foundation

enum SignUpModelIndex: Int {
    case username = 0
    case password
    case confirmPassword
    case company
    case phone
}

class SignUpCellModel {
    var modelIndex: SignUpModelIndex
    var title: String?
    var content: String?
    
    init(index: SignUpModelIndex, title: String? = nil, content: String? = nil) {
        self.modelIndex = index
        self.title = title
        self.content = content
    }
}

final class SignUpDataSource {
    public let models: [SignUpCellModel]
    
    init() {
        let usernameModel = SignUpCellModel(index: .username, title: Localization.text(key: "Username"), content: "")
        let passwordModel = SignUpCellModel(index: .password, title: Localization.text(key: "Password"), content: "")
        let confirmPasswordModel = SignUpCellModel(index: .confirmPassword, title: Localization.text(key: "ConfirmPassword"), content: "")
        let companyModel = SignUpCellModel(index: .company, title: Localization.text(key: "Company"), content: "")
        let phoneModel = SignUpCellModel(index: .phone, title: Localization.text(key: "Phone"), content: "")
        
        models = [
            usernameModel,
            passwordModel,
            confirmPasswordModel,
            companyModel,
            phoneModel
        ]
    }
}
