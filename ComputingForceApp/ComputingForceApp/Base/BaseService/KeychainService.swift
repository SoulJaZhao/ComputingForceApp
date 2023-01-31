//
//  KeychainService.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/31.
//

import Foundation
import KeychainAccess

protocol KeychainServiceProtocol {
    func store(username: String, password: String)
    func getUsernameAndPassword() -> (username: String?, password: String?)
    func removeAll()
}

class KeychainService: KeychainServiceProtocol {
    static let service = "com.soulja.ComputingForceApp"
    
    enum KeychainKey : String {
        case username = "username"
        case password = "password"
    }
    
    let keychain: Keychain
    
    init() {
        keychain = Keychain(service: KeychainService.service)
    }
    
    func store(username: String, password: String) {
        try? keychain.set(username, key: KeychainKey.username.rawValue)
        try? keychain.set(password, key: KeychainKey.password.rawValue)
    }
    
    func getUsernameAndPassword() -> (username: String?, password: String?) {
        let username = try? keychain.get(KeychainKey.username.rawValue)
        let password = try? keychain.get(KeychainKey.password.rawValue)
        
        return (username, password)
    }
    
    func removeAll() {
        try? keychain.removeAll()
    }
}
