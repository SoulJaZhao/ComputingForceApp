//
//  BaseViewModel.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/10.
//

import Foundation
import Combine

class BaseViewModel {
    enum RefreshHeaderEvent {
        case start
        case stop
    }
    
    enum LoadingEvent {
        case on
        case off
    }
    
    enum AlertEvent {
        case genericAlert
    }
    
    func getXibName() -> String {
        fatalError("must override this func")
    }
    
    let loadingEventSubject = PassthroughSubject<LoadingEvent, Never>()
    let alertEventSubject = PassthroughSubject<AlertEvent, Never>()
}
