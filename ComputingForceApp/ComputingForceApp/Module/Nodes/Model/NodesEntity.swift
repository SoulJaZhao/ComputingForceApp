//
//  NodesEntity.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/2/5.
//

import Foundation

struct CityNode {
    var name: String
    var count: Int
    
    init(name: String, count: Int) {
        self.name = name
        self.count = count
    }
}

struct Node: Decodable {
    public private(set) var nodeID: Int?
    public private(set) var elementId: String?
    public private(set) var labels: [String]?
    public private(set) var properties: NodeProperty?
    
    private enum CodingKeys: String, CodingKey {
        case nodeID         =   "Id"
        case elementId      =   "ElementId"
        case labels         =   "Labels"
        case properties     =   "Props"
    }
    
    public init(from decoder: Decoder) throws {
        let KDC: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        nodeID = try KDC.decodeIfPresent(Int.self, forKey: .nodeID)
        elementId = try KDC.decodeIfPresent(String.self, forKey: .elementId)
        labels = try KDC.decodeIfPresent([String].self, forKey: .labels)
        properties = try KDC.decodeIfPresent(NodeProperty.self, forKey: .properties)
    }
}

struct NodeProperty: Decodable {
    public private(set) var CPU: String?
    public private(set) var extData: String?
    public private(set) var GPU: String?
    public private(set) var harddisk: String?
    public private(set) var IP: String?
    public private(set) var memory: String?
    public private(set) var OS: String?
    public private(set) var name: String?
    
    private enum CodingKeys: String, CodingKey {
        case CPU            =   "CPU"
        case GPU            =   "GPU"
        case extData        =   "ExtData"
        case harddisk       =   "Harddisk"
        case IP             =   "IP"
        case memory         =   "Memory"
        case OS             =   "OS"
        case name           =   "name"
    }
    
    public init(from decoder: Decoder) throws {
        let KDC: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        CPU = try KDC.decodeIfPresent(String.self, forKey: .CPU)
        GPU = try KDC.decodeIfPresent(String.self, forKey: .GPU)
        extData = try KDC.decodeIfPresent(String.self, forKey: .extData)
        harddisk = try KDC.decodeIfPresent(String.self, forKey: .harddisk)
        IP = try KDC.decodeIfPresent(String.self, forKey: .IP)
        memory = try KDC.decodeIfPresent(String.self, forKey: .memory)
        OS = try KDC.decodeIfPresent(String.self, forKey: .OS)
        name = try KDC.decodeIfPresent(String.self, forKey: .name)
    }
}
