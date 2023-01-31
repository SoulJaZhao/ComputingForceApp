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
}
