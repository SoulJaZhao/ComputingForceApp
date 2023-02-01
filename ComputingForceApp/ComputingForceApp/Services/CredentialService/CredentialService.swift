//
//  CredentialService.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/2/1.
//

import Foundation

protocol CrendentialServiceProtocol {
    var user: User? { get }
    var accessToken: String? { get }
    func set(user: User?)
    func refreshAccessToken(token: String?)
    func clear()
}

final class CrendentialService: CrendentialServiceProtocol {
    
    private(set) var user: User?
    private(set) var accessToken: String?
    
    func set(user: User?) {
        if let unwrappedUser = user {
            self.user = unwrappedUser
            self.accessToken = unwrappedUser.token
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
