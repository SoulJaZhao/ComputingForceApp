//
//  Theme.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/13.
//

import Foundation
import UIKit
import Hue

final class Theme {
    let smallFontSize: CGFloat = 14
    let largeFontSize: CGFloat = 24
    
    let whiteColor: UIColor = .white
    let blackColor: UIColor = .black
    let blueButtonGradientStartColor = UIColor.init(hex: "4EC9E3")
    let blueButtonGradientEndColor = UIColor.init(hex: "027EBC")
    
    lazy var smallFont = UIFont.systemFont(ofSize: smallFontSize)
    lazy var largeBoldFont = UIFont.boldSystemFont(ofSize: largeFontSize)
    
}
