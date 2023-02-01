//
//  DependencyInjectionService.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/31.
//

import Foundation
import Swinject

struct DependencyInjectionService {
    let container = Container(defaultObjectScope: .container)
    
    func registerServices() {
        container.register(KeychainServiceProtocol.self) { _ in
            KeychainService()
        }.inObjectScope(.container)
        
        container.register(CrendentialServiceProtocol.self) { _ in
            CrendentialService()
        }
    }
    
    func removeAll() {
        container.removeAll()
    }
    
    func refreshServices() {
        self.removeAll()
        self.registerServices()
    }
}
