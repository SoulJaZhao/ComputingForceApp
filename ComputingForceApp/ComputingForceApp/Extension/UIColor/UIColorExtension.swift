//
//  UIColorExtension.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/13.
//

import Foundation
import UIKit
import SwiftEntryKit

extension UIColor {
    
    static var navigationBatItemColor: UIColor = .black
    static var navigationBatItemDisabledColor: UIColor = .lightGray
    

    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
