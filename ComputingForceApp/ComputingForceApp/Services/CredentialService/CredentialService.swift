//
//  CredentialService.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/2/1.
//

import Foundation
import Combine

final class CredentialService {
    
    @Published private(set) var user: User?
    @Published private(set) var accessToken: String?
    
    var isLoggedIn: Bool {
        return user != nil && accessToken != nil
    }
    
    func set(user: User?) {
        if let unwrappedUser = user {
            self.user = unwrappedUser
            self.refreshAccessToken(token: unwrappedUser.token)
        } else {
            self.user = nil
            self.refreshAccessToken(token: nil)
        }
    }
    
    func refreshAccessToken(token: String?) {
        self.accessToken = token
    }
    
    func clear() {
        set(user: nil)
    }
}
