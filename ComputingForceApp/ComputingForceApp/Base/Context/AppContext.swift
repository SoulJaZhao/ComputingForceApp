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
    
    
    let router: Router
    let theme: Theme
    let environment: Environment
    let dependencyInjection: DependencyInjectionService
    
    let appEventSubject: PassthroughSubject<AppEventType, Never> = PassthroughSubject()
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        router = Router()
        theme = Theme()
        environment = Environment(type: .test)
        dependencyInjection = DependencyInjectionService()
        dependencyInjection.registerServices()
        
        appEventSubject
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .logout:
                    self.router.transitionEvent.send(.landing)
                }
            }
            .store(in: &cancellables)
    }
}
