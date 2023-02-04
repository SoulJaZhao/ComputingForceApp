//
//  AuthenticationService.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/31.
//

import Foundation
import Combine
import Moya

enum Authentication {
    case login(username: String, password: String)
}

extension Authentication : TargetType {
    
    var baseURL: URL {
        URL(string: AppContext.context.environment.hostPath)!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/api/\(AppContext.context.environment.version.rawValue)/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .login(let username, let password):
            return .requestParameters(parameters: ["username" : username, "password" : password], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}

class AuthenticationService: NetworkServiceProtocol {
    typealias AbstractType = Authentication
    
    private var cancellables = Set<AnyCancellable>()
    
    func login(username: String, password: String) -> AnyPublisher<User, APIError> {
        return self.excute(target: .login(username: username, password: password),
                           responseModel: User.self)
    }
}
