//
//  LaunchViewModel.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/13.
//

import Foundation
import Combine

class LaunchViewModel: BaseViewModel {
    
    override func getXibName() -> String {
        return "LaunchViewController"
    }
    
    let skipTime: Int = 3
    let transitionEvent = PassthroughSubject<Router.Route, Never>()
}
