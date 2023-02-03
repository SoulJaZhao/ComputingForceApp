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
    var credentailService: CredentialService? {
        AppContext.context.dependencyInjection.container.resolve(CredentialService.self)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func validateLoginStatus() {
        if credentailService?.isLoggedIn == false {
            viewOutputEvent.send(.transition(.landing))
        }
    }
}
