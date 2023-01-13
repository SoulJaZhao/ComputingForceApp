//
//  UIViewExtension.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/13.
//

import Foundation
import UIKit

extension UIView {

    func applyGradient(colors: [UIColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
