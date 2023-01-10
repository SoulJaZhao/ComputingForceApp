//
//  File.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/10.
//

import Foundation
import Combine
import URLNavigator

final class Router {
    enum Route: String {
        case landing = "app://landing"
    }
    
    var mainTabbarController: BaseTabBarController?
    private let navigator: Navigator
    private var cancellables = Set<AnyCancellable>()
    
    let transitionEvent: PassthroughSubject<Router.Route, Never> = PassthroughSubject()
    
    init() {
        navigator = Navigator()
        
        transitionEvent
            .receive(on: RunLoop.main)
            .sink { route in
                self.transitionEventHandler(route: route)
            }
            .store(in: &cancellables)
    }
    
    private func transitionEventHandler(route: Route) {
        switch route {
        case .landing:
            let landingViewModel = LandingViewModel()
            let landingViewController = LandingViewController(viewModel: landingViewModel)
            
            mainTabbarController?.selectedIndex = 0
            navigator.present(landingViewController, wrap: BaseNavigationController.self)
        }
    }
}
