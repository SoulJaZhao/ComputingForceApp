//
//  LandingViewController.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/10.
//

import UIKit
import Combine
import SDWebImage

class LandingViewController: BaseViewController<LandingViewModel> {
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
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
        signInBtn.titleLabel?.font = AppContext.context.theme.largeBoldFont
        signUpBtn.titleLabel?.font = AppContext.context.theme.largeBoldFont
        signInBtn.applyGradient(colors: [AppContext.context.theme.blueButtonGradientStartColor, AppContext.context.theme.blueButtonGradientEndColor])
        signUpBtn.setBackgroundColor(color: AppContext.context.theme.whiteColor, forState: .normal)
        signInBtn.setTitleColor(AppContext.context.theme.whiteColor, for: .normal)
        signUpBtn.setTitleColor(AppContext.context.theme.blackColor, for: .normal)
        signInBtn.layer.cornerRadius = 8
        signInBtn.layer.masksToBounds = true
        signInBtn.clipsToBounds = true
        signUpBtn.layer.cornerRadius = 8
        signUpBtn.layer.masksToBounds = true
        signUpBtn.clipsToBounds = true
        
        let gifImageView = SDAnimatedImageView(frame: self.view.bounds)
        let gifImage = SDAnimatedImage(named: "Landing0.gif")
        gifImageView.image = gifImage
        self.view.insertSubview(gifImageView, at: 0)
        
        
        signInBtn
            .controlEventPublisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.viewOutputSubject.send(.transition(.signIn))
            }
            .store(in: &subscriptions)
        
        signUpBtn
            .controlEventPublisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.viewOutputSubject.send(.transition(.signUp))
            }
            .store(in: &subscriptions)
    }
}
