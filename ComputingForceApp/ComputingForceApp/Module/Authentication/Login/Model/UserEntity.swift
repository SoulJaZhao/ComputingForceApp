//
//  UserEntity.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/31.
//

import Foundation

struct User: Codable {
    public private(set) var userID: Int?
    public private(set) var roleID: Int?
    public private(set) var realName: String?
    public private(set) var userName: String?
    public private(set) var creator: String?
    public private(set) var createdAt: String?
    public private(set) var updatedAt: String?
    public private(set) var token: String?
    public private(set) var role: Role?
    
    
    private enum CodingKeys: String, CodingKey {
        case userID         =   "id"
        case roleID         =   "roleID"
        case realName       =   "realName"
        case userName       =   "userName"
        case creator        =   "creator"
        case createdAt      =   "createdAt"
        case updatedAt      =   "updatedAt"
        case token          =   "token"
        case role           =   "role"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userID, forKey: .userID)
        try container.encode(roleID, forKey: .roleID)
        try container.encode(realName, forKey: .realName)
        try container.encode(userName, forKey: .userName)
        try container.encode(creator, forKey: .creator)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encode(token, forKey: .token)
        try container.encode(role, forKey: .role)
      }
    
    init(token: String) {
        self.token = token
    }
    
    public init(from decoder: Decoder) throws {
        let KDC: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        userID = try KDC.decodeIfPresent(Int.self, forKey: .userID)
        roleID = try KDC.decodeIfPresent(Int.self, forKey: .roleID)
        realName = try KDC.decodeIfPresent(String.self, forKey: .realName)
        userName = try KDC.decodeIfPresent(String.self, forKey: .userName)
        creator = try KDC.decodeIfPresent(String.self, forKey: .creator)
        createdAt = try KDC.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try KDC.decodeIfPresent(String.self, forKey: .updatedAt)
        token = try KDC.decodeIfPresent(String.self, forKey: .token)
        role = try KDC.decodeIfPresent(Role.self, forKey: .role)
    }
}

struct Role: Codable {
    public private(set) var roleID: Int?
    public private(set) var name: String?
    public private(set) var description: String?
    public private(set) var creator: String?
    public private(set) var createdAt: String?
    public private(set) var updatedAt: String?
    
    private enum CodingKeys: String, CodingKey {
        case roleID         =   "id"
        case name           =   "realName"
        case description    =   "userName"
        case creator        =   "creator"
        case createdAt      =   "createdAt"
        case updatedAt      =   "updatedAt"
    }
    
    public init(from decoder: Decoder) throws {
        let KDC: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        roleID = try KDC.decodeIfPresent(Int.self, forKey: .roleID)
        name = try KDC.decodeIfPresent(String.self, forKey: .name)
        description = try KDC.decodeIfPresent(String.self, forKey: .description)
        creator = try KDC.decodeIfPresent(String.self, forKey: .creator)
        createdAt = try KDC.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try KDC.decodeIfPresent(String.self, forKey: .updatedAt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(roleID, forKey: .roleID)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(creator, forKey: .creator)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
      }
}
