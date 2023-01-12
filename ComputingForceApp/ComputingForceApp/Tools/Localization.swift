//
//  Localization.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/12.
//

import Foundation

struct Localization {
    
    static func text(key: String) -> String? {
        return NSLocalizedString(key, comment: key)
    }
}
