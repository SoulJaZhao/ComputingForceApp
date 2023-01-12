//
//  LandingViewController.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/10.
//

import UIKit
import Combine

class LandingViewController: BaseViewController<LandingViewModel> {
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func bind(viewModel: LandingViewModel, storeBindingsIn cancellables: inout Set<AnyCancellable>) {
        super.bind(viewModel: viewModel, storeBindingsIn: &subscriptions)
        
        viewModel
            .transitionPublisher
            .receive(on: RunLoop.main)
            .sink { transition in
                switch transition {
                case .signIn:
                    AppContext.context.router.transitionEvent.send(.signIn)
                case .signUp:
                    AppContext.context.router.transitionEvent.send(.signUp)
                }
            }
            .store(in: &subscriptions)
    }
    
    private func setupUI() {
        signInBtn.setTitle(Localization.text(key: "SignIn"), for: .normal)
        signUpBtn.setTitle(Localization.text(key: "SignUp"), for: .normal)
        
        signInBtn
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.viewOutputSubject.send(.transition(.signIn))
            }
            .store(in: &subscriptions)
        
        signUpBtn
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.viewOutputSubject.send(.transition(.signUp))
            }
            .store(in: &subscriptions)
    }
}
