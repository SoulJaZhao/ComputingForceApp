//
//  BaseViewModel.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/10.
//

import Foundation
import Combine

class BaseViewModel {
    func getXibName() -> String {
        fatalError("must override this func")
    }
}
