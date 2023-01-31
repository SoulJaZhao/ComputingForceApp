//
//  BaseService.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/31.
//

import Foundation
import Combine
import Moya

enum APIError : Error {
    case unknown
    case httpError(ErrorModel)
    case internalError(MoyaError)
}

protocol ServiceProtocol {
    associatedtype AbstractType: TargetType
    var provider: MoyaProvider<AbstractType> { get }
}

extension ServiceProtocol {
    var provider: MoyaProvider<AbstractType> {
        MoyaProvider<AbstractType>()
    }
    
    func excute<T>(target: AbstractType, responseModel: T.Type) -> AnyPublisher<T, APIError> where T: Decodable {
        Future<T, APIError> { promise in
            self.provider.request(target) { result in
                switch result {
                case let .success(moyaResponse):
                    do {
                        let filteredResponse = try moyaResponse.filterSuccessfulStatusCodes()
                        let response = try filteredResponse.map(responseModel, atKeyPath: "data")
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
