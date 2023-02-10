//
//  NodeViewModel.swift
//  ComputingForceApp
//
//  Created by Long Zhao on 2023/2/10.
//

import UIKit
import Combine

class NodeViewModel: BaseViewModel {
    
    enum SectionType: Int {
        case nodeID = 0
        case elementID
        case labels
        case properties
        
        var title: String? {
            switch self {
            case .nodeID:
                return Localization.text(key: "NodeID")
            case .elementID:
                return Localization.text(key: "ElementID")
            case .labels:
                return Localization.text(key: "Labels")
            case .properties:
                return Localization.text(key: "Properties")
            }
        }
    }
    
    enum PropertyRowType: Int {
        case gpu = 0
        case cpu
        case extData
        case hardDisk
        case memory
        case ip
        case os
        case name
        
        var title: String? {
            switch self {
            case .gpu:
                return Localization.text(key: "GPU")
            case .cpu:
                return Localization.text(key: "CPU")
            case .extData:
                return Localization.text(key: "ExtData")
            case .hardDisk:
                return Localization.text(key: "HardDisk")
            case .memory:
                return Localization.text(key: "Memory")
            case .ip:
                return Localization.text(key: "IP")
            case .os:
                return Localization.text(key: "OS")
            case .name:
                return Localization.text(key: "Name")
            }
        }
    }
    
    override func getXibName() -> String {
        return "NodeViewController"
    }
    
    let cellIdentifier: String = "NodeCell"
    
    let node: Node
    
    init(node: Node) {
        self.node = node
        super.init()
    }
    
    func titleForHeader(section: Int) -> String? {
        let section = SectionType(rawValue: section)
        return section?.title
    }
    
    func numberOfRows(section: Int) -> Int {
        let section = SectionType(rawValue: section)
        
        switch section {
        case .nodeID, .elementID, .labels:
            return 1
        case .properties:
            return 8
        case .none:
            return 0
        }
    }
}
