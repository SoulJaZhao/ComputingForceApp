//
//  UITextfieldExtension.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/14.
//

import UIKit
import Combine

extension UITextField {

    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(
            for: UITextField.textDidChangeNotification,
            object: self
        )
        .compactMap { ($0.object as? UITextField)?.text }
        .eraseToAnyPublisher()
    }

}
