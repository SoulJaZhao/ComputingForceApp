//
//  BaseModel.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/31.
//

import Foundation

struct BaseModel<T: Decodable>: Decodable {
    public private(set) var code: Int?
    public private(set) var message: String?
    public private(set) var data: T?
    
    private enum CodingKeys: String, CodingKey {
        case code       =   "code"
        case message    =   "message"
        case data       =   "data"
    }
    
    public init(from decoder: Decoder) throws {
        let KDC: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        code = try KDC.decodeIfPresent(Int.self, forKey: .code)
        message = try KDC.decodeIfPresent(String.self, forKey: .message)
        data = try KDC.decodeIfPresent(T.self, forKey: .data)
    }
}

struct ErrorModel: Decodable {
    public private(set) var code: Int?
    public private(set) var message: String?
    public private(set) var data: String?
    
    private enum CodingKeys: String, CodingKey {
        case code       =   "code"
        case message    =   "message"
        case data       =   "data"
    }
    
    public init(from decoder: Decoder) throws {
        let KDC: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        code = try KDC.decodeIfPresent(Int.self, forKey: .code)
        message = try KDC.decodeIfPresent(String.self, forKey: .message)
        data = try KDC.decodeIfPresent(String.self, forKey: .data)
    }
}
