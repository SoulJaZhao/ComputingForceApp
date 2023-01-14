//
//  UIImageExtension.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/13.
//

import UIKit

extension UIImage {
    /**
     Create gradient image from beginColor on top and end color at bottom
     
     - parameter beginColor: beginColor
     - parameter endColor:   endColor
     - parameter frame:      frame to be filled
     
     - returns: filled image
     */
    static func imageWithGradient(from beginColor: UIColor, to endColor: UIColor, with frame: CGRect) -> UIImage {
        let layer = CAGradientLayer()
        layer.frame = frame
        layer.colors = [beginColor.cgColor, endColor.cgColor]
        UIGraphicsBeginImageContext(CGSize(width: frame.width, height: frame.height))
        layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return image
    }
}
