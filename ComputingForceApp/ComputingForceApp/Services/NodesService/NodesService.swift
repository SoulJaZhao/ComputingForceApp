//
//  NodesService.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/2/5.
//

import Foundation
import Combine
import Moya

enum NodeAPI {
    case sumAllCity
    case findNodes(cityNode: CityNode)
}

extension NodeAPI : TargetType {
    
    var accessToken : String {
        AppContext.context.dependencyInjection.container.resolve(CredentialService.self)?.accessToken ?? ""
    }
    
    var baseURL: URL {
        URL(string: AppContext.context.environment.hostPath)!
    }
    
    var path: String {
        switch self {
        case .sumAllCity:
            return "/api/\(AppContext.context.environment.version.rawValue)/neo4j/find/sumAllCity"
        case .findNodes(cityNode: _):
            return "/api/\(AppContext.context.environment.version.rawValue)/neo4j/find/byCity"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .sumAllCity, .findNodes(cityNode: _):
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .sumAllCity:
            return .requestPlain
        case .findNodes(cityNode: let node):
            return .requestParameters(parameters: ["city" : node.name], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-type"  :   "application/json",
            "Authorization" :   "Bearer \(accessToken)"
        ]
    }
}

class NodesService: NetworkServiceProtocol {
    typealias AbstractType = NodeAPI
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchSummuryForEachCity() -> AnyPublisher<[CityNode], APIError> {
        return self.excute(target: .sumAllCity, responseModel: Dictionary<String, Int>.self)
            .flatMap { dict in
                var sortedNodes: [CityNode] = []
                
                let nodes: [CityNode] = dict.map { key, value in
                    CityNode(name: key, count: value)
                }
                
                let filteredNodes = nodes.filter { node in
                    node.count > 0
                }
                
                sortedNodes = filteredNodes.sorted(by: {
                    if ($0.count == $1.count) {
                        return $0.name < $1.name
                    }
                    return $0.count > $1.count
                })
                
                return Just(sortedNodes)
            }
            .eraseToAnyPublisher()
    }
    
    func fetchNodes(cityNode: CityNode) -> AnyPublisher<[Node], APIError> {
        return self.excute(target: .findNodes(cityNode: cityNode), responseModel: [Node].self)
            .eraseToAnyPublisher()
    }
}
