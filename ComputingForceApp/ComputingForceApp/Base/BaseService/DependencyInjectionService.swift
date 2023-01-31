//
//  DependencyInjectionService.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/31.
//

import Foundation
import Swinject

struct DependencyInjectionService {
    let container = Container()
    
    func registerServices() {
        container.register(KeychainServiceProtocol.self) { _ in
            KeychainService()
        }
    }
    
    func removeAll() {
        container.removeAll()
    }
}
