//
//  BaseTabBarController.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/10.
//

import UIKit
import Combine

class BaseTabBarController: UITabBarController {
    
    let viewModel: BaseTabBarViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: BaseTabBarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribeToViewModel()
        setupViewControllers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.validateLoginStatus()
    }
    
    func subscribeToViewModel() {
        viewModel.viewOutputEventPublisher
            .sink { event in
                switch event {
                case .transition(let destination):
                    if case .landing = destination {
                        AppContext.context.appEventSubject.send(.logout)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupViewControllers() {
        self.viewControllers = viewModel.subViewControllers()
    }
    
    private func setupUI() {
        
    }
}
