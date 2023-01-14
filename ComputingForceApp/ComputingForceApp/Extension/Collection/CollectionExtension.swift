//
//  CollectionExtension.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/14.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it exists, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
