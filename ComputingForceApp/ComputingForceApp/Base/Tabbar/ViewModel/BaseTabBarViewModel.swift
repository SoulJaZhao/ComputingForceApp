//
//  BaseTabBarViewModel.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/10.
//

import Foundation
import Combine

final class BaseTabBarViewModel {
    
    enum Transition {
        case landing
    }
    
    enum ViewOutputEvent {
        case transition(Transition)
    }
    
    
    public lazy var viewOutputEventPublisher: AnyPublisher = self.viewOutputEvent.eraseToAnyPublisher()
    private var viewOutputEvent: PassthroughSubject<ViewOutputEvent, Never> = PassthroughSubject()
    
    func validateLoginStatus() {
        // TODO: Checking loading status
        viewOutputEvent.send(.transition(.landing))
    }
}
