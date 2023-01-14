//
//  LoginViewController.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/12.
//

import UIKit
import Combine

class LoginViewController: BaseViewController<LoginViewModel> {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var rememberMeBtn: UIButton!
    @IBOutlet weak var rememberMeLabel: UILabel!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var usernameContainerView: UIView!
    @IBOutlet weak var passwordContainerView: UIView!
    private var cancellables = Set<AnyCancellable>()
    
    private var isValidUsernmae: AnyPublisher<Bool, Never> {
        viewModel.$username
            .map { username in
                return username.count > 0
            }
            .eraseToAnyPublisher()
    }
    
    private var isValidPassword: AnyPublisher<Bool, Never> {
        viewModel.$password
            .map { password in
                return password.count > 0
            }
            .eraseToAnyPublisher()
    }
    
    private var isLoginEnable: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isValidUsernmae, isValidPassword)
            .map {
                $0 && $1
            }
            .eraseToAnyPublisher()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func bind(viewModel: LoginViewModel, storeBindingsIn cancellables: inout Set<AnyCancellable>) {
        super.bind(viewModel: viewModel, storeBindingsIn: &cancellables)
        viewModel.$isRemeberMe
            .receive(on: RunLoop.main)
            .sink { [weak self] isChecked in
                guard let self = self else { return }
                if (isChecked == true) {
                    self.rememberMeBtn.setBackgroundImage(UIImage(named: "CheckedBox"), for: .normal)
                } else {
                    self.rememberMeBtn.setBackgroundImage(UIImage(named: "UncheckedBox"), for: .normal)
                }
            }
            .store(in: &cancellables)
        
        isLoginEnable
            .receive(on: RunLoop.main)
            .sink { [weak self] enable in
                guard let self = self else { return }
                self.loginBtn.isEnabled = enable
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        let theme = AppContext.context.theme
        
        self.title = Localization.text(key: "SignIn")
        
        loginBtn.setTitle(Localization.text(key: "SignIn"), for: .normal)
        loginBtn.titleLabel?.font = theme.largeBoldFont
        loginBtn.setTitleColor(theme.whiteColor, for: .normal)
        let enableImage = UIImage.imageWithGradient(from: theme.blueButtonGradientStartColor, to: theme.blueButtonGradientEndColor, with: loginBtn.bounds)
        loginBtn.setBackgroundImage(enableImage, for: .normal)
        loginBtn.setBackgroundColor(color: .lightGray, forState: .disabled)
        loginBtn.layer.cornerRadius = theme.cornerRadius
        loginBtn.layer.masksToBounds = true
        loginBtn.clipsToBounds = true
        
        
        usernameContainerView.backgroundColor = theme.backggroundColor
        usernameContainerView.layer.borderColor = theme.textfieldBorderColor.cgColor
        usernameContainerView.layer.borderWidth = 1.5
        usernameContainerView.layer.cornerRadius = theme.cornerRadius
        usernameContainerView.layer.masksToBounds = true
        usernameContainerView.clipsToBounds = true
        
        usernameTextField.placeholder = Localization.text(key: "Username")
        
        passwordContainerView.backgroundColor = theme.backggroundColor
        passwordContainerView.layer.borderColor = theme.textfieldBorderColor.cgColor
        passwordContainerView.layer.borderWidth = 1.5
        passwordContainerView.layer.cornerRadius = theme.cornerRadius
        passwordContainerView.layer.masksToBounds = true
        passwordContainerView.clipsToBounds = true
        
        passwordTextField.placeholder = Localization.text(key: "Password")
        
        rememberMeLabel.text = Localization.text(key: "RememberMe")
        rememberMeLabel.font = theme.mediumFont
        rememberMeLabel.textColor = theme.darkLabelTitleColor
        
        forgotPasswordBtn.setTitleColor(theme.darkLabelTitleColor, for: .normal)
        forgotPasswordBtn.titleLabel?.font = theme.mediumFont
        forgotPasswordBtn.setTitle(Localization.text(key: "ForgotPassword"), for: .normal)
        
        rememberMeBtn.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.isRemeberMe = !self.viewModel.isRemeberMe
            }
            .store(in: &cancellables)
        
        usernameTextField.textPublisher
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                self?.viewModel.username = text
            }
            .store(in: &cancellables)
        
        passwordTextField.textPublisher
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                self?.viewModel.password = text
            }
            .store(in: &cancellables)
        
        loginBtn.publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .sink { _ in
                print("login")
            }
            .store(in: &cancellables)
    }
}
