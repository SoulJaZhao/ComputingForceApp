//
//  Environment.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/31.
//

import Foundation

struct Environment {
    enum EnvironmentType {
    case test
    }
    
    enum HostPath: String {
    case test = "http://8.142.88.173"
    }
    
    enum APIVersion: String {
        case v1 = "v1"
    }
    
    private(set) var type: EnvironmentType
    private(set) var hostPath: String = ""
    private(set) var version: APIVersion = .v1
    
    init(type: EnvironmentType) {
        self.type = type
        
        switch type {
        case .test:
            hostPath = HostPath.test.rawValue
            version = .v1
        }
    }
}
