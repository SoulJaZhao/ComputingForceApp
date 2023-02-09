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
    case insertCity(province: String, city: String, attribute: [String : Any])
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
        case .insertCity:
            return "/api/\(AppContext.context.environment.version.rawValue)/neo4j/insert/city"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .sumAllCity, .findNodes(cityNode: _):
            return .get
        case .insertCity:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .sumAllCity:
            return .requestPlain
        case .findNodes(cityNode: let node):
            return .requestParameters(parameters: ["city" : node.name], encoding: URLEncoding.default)
        case .insertCity(province: let province, city: let city, attribute: let attribute):
            let dict: [String : Any] = [
                "province"  :   province,
                "city"      :   city,
                "attribute" :   attribute
            ]
            return .requestParameters(parameters: dict, encoding: JSONEncoding.default)
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
                    node.count >= 0
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
    
    func addCityNode(province: String, city: String, atributes: [AddCityNodeRowViewModel]) -> AnyPublisher<[String], APIError> {
        var attributeDict: [String : Any] = [:]
        atributes.forEach { row in
            attributeDict[row.key ?? ""] = row.value
        }
        
        return self.excute(target: .insertCity(province: province, city: city, attribute: attributeDict), responseModel: [String].self)
            .eraseToAnyPublisher()
    }
}
