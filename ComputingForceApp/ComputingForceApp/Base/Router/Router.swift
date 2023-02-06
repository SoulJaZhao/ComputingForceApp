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
        case launchView         = "app://launchView"
        case mainView           = "app://mainView"
        case landing            = "app://landing"
        case signIn             = "app://signIn"
        case signUp             = "app://signUp"
        case ComputingNodes     = "app://computingNodes"
    }
    
    var mainTabbarController: BaseTabBarController?
    var computingNodesNavigationController: BaseNavigationController?
    private let navigator: Navigator
    private var cancellables = Set<AnyCancellable>()
    var keyWindow: UIWindow {
        UIApplication.shared.windows.first { $0.isKeyWindow } ?? UIWindow(frame: .zero)
    }
    
    let transitionEvent: PassthroughSubject<Router.Route, Never> = PassthroughSubject()
    
    init() {
        navigator = Navigator()
        
        registerViewControllers()
        
        transitionEvent
            .receive(on: RunLoop.main)
            .sink { route in
                self.transitionEventHandler(route: route)
            }
            .store(in: &cancellables)
    }
    
    public func getViewController(route: Router.Route) -> UIViewController? {
        return navigator.viewController(for: route.rawValue)
    }
    
    private func registerViewControllers() {
        navigator.register(Route.launchView.rawValue) { _, _, _ in
            let viewModel = LaunchViewModel()
            let launchViewController = LaunchViewController(viewModel: viewModel)
            return launchViewController
        }

        navigator.register(Route.mainView.rawValue) { _, _, _ in
            let viewModel = BaseTabBarViewModel()
            let tabarController = BaseTabBarController(viewModel: viewModel)
            self.mainTabbarController = tabarController
            return self.mainTabbarController
        }
        
        navigator.register(Route.ComputingNodes.rawValue) { _, _, _ in
            let viewModel = NodesListViewModel()
            let controller = NodesListViewController(viewModel: viewModel)
            controller.tabBarItem = viewModel.tabbarItem
            controller.hidesBottomBarWhenPushed = true
            return controller
        }
    }
    
    private func transitionEventHandler(route: Route) {
        switch route {
        case .landing:
            let landingViewModel = LandingViewModel()
            let landingViewController = LandingViewController(viewModel: landingViewModel)
            mainTabbarController?.selectedIndex = 0
            navigator.present(landingViewController, wrap: BaseNavigationController.self)
        case .signIn:
            let loginViewModel = LoginViewModel()
            let loginViewController = LoginViewController(viewModel: loginViewModel)
            navigator.push(loginViewController)
        case .signUp:
            let signUpViewModel = SignUpViewModel()
            let signUpViewController = SignUpViewController(viewModel: signUpViewModel)
            navigator.push(signUpViewController)
        case .mainView:
            self.keyWindow.rootViewController = self.getViewController(route: .mainView)
        default:
            break
        }
    }
}
