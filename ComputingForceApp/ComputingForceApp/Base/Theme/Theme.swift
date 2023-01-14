//
//  Theme.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/13.
//

import Foundation
import UIKit
import Hue

struct Theme {
    let smallFontSize: CGFloat = 14
    let mediumFontSize: CGFloat = 18
    let largeFontSize: CGFloat = 24
    
    let cornerRadius: CGFloat = 8
    
    let whiteColor: UIColor = .white
    let blackColor: UIColor = .black
    let blueButtonGradientStartColor = UIColor.init(hex: "4EC9E3")
    let blueButtonGradientEndColor = UIColor.init(hex: "027EBC")
    let navigationBarColor = UIColor.init(hex: "F9F9F9")
    let backggroundColor = UIColor.init(hex: "F5F4F4")
    let textfieldBorderColor = UIColor.init(hex: "6F6F6F")
    let darkLabelTitleColor = UIColor.init(hex: "353535")
    
    let smallFont: UIFont
    let mediumFont: UIFont
    let largeBoldFont: UIFont
    
    init() {
        smallFont = UIFont.systemFont(ofSize: smallFontSize)
        mediumFont = UIFont.systemFont(ofSize: mediumFontSize)
        largeBoldFont = UIFont.boldSystemFont(ofSize: largeFontSize)
    }
    
}
