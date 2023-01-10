//
//  AppContext.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/10.
//

import Foundation
import Swinject
import URLNavigator
import Combine

final class AppContext {
    enum AppEventType {
        case logout
    }
    
    static let context = AppContext()
    
    let dependencyInjectionContainer: Container
    let router: Router
    
    let appEventSubject: PassthroughSubject<AppEventType, Never> = PassthroughSubject()
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        dependencyInjectionContainer = Container()
        router = Router()
        
        appEventSubject
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .logout:
                    self.dependencyInjectionContainer.removeAll()
                    self.router.transitionEvent.send(.landing)
                }
            }
            .store(in: &cancellables)
    }
}
