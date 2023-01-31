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
            return "/api/v1/login"
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

class AuthenticationService: ServiceProtocol {
    typealias AbstractType = Authentication
    
    private var cancellables = Set<AnyCancellable>()
    
    func login(username: String, password: String) -> AnyPublisher<User, APIError> {
        Future<User, APIError> { promise in
            self.provider.request(.login(username: username, password: password)) { result in
                switch result {
                case let .success(moyaResponse):
                    do {
                        let filteredResponse = try moyaResponse.filterSuccessfulStatusCodes()
                        let response = try filteredResponse.map(User.self, atKeyPath: "data")
                        promise(.success(response))
                    } catch {
                        do {
                            let error = try moyaResponse.map(ErrorModel.self)
                            promise(.failure(.httpError(error)))
                        } catch {
                            promise(.failure(.unknown))
                        }
                    }
                case let .failure(error):
                    promise(.failure(.internalError(error)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
