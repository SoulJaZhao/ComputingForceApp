//
//  SignUpViewController.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/12.
//

import UIKit
import Combine

class SignUpViewController: BaseViewController<SignUpViewModel> {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var signUpBtn: UIButton!
    
    
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
    
    private var isValidConfirmPassword: AnyPublisher<Bool, Never> {
        viewModel.$confirmPassword
            .map { [weak self] confirmPassword in
                guard let self = self else { return false }
                return confirmPassword.count > 0 && confirmPassword == self.viewModel.password
            }
            .eraseToAnyPublisher()
    }
    
    private var isValidCompany: AnyPublisher<Bool, Never> {
        viewModel.$company
            .map { company in
                return company.count > 0
            }
            .eraseToAnyPublisher()
    }
    
    private var isValidPhone: AnyPublisher<Bool, Never> {
        viewModel.$phone
            .map { phone in
                return phone.count > 0
            }
            .eraseToAnyPublisher()
    }
    
    private var isSignUpEnable: AnyPublisher<Bool, Never> {
        let combine0 = Publishers.CombineLatest3(isValidUsernmae, isValidPassword, isValidConfirmPassword)
            .map {
                $0 && $1 && $2
            }

        let combine1 = Publishers.CombineLatest(isValidCompany, isValidPhone)
            .map {
                $0 && $1
            }
        
        return Publishers.CombineLatest(combine0, combine1)
            .map {
                $0 && $1
            }
            .eraseToAnyPublisher()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func bind(viewModel: SignUpViewModel, storeBindingsIn cancellables: inout Set<AnyCancellable>) {
        super.bind(viewModel: viewModel, storeBindingsIn: &cancellables)
        
        isSignUpEnable
            .receive(on: RunLoop.main)
            .sink { [weak self] enable in
                guard let self = self else { return }
                self.signUpBtn.isEnabled = enable
            }
            .store(in: &cancellables)
    }

    private func setupUI() {
        let theme = AppContext.context.theme
        
        self.title = Localization.text(key: "SignUp")
        tableView.backgroundColor = theme.backggroundColor
        let nib = UINib(nibName: viewModel.cellIdentifier, bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: viewModel.cellIdentifier)
        tableView.estimatedRowHeight = 180
        tableView.sectionHeaderHeight = 0.01
        tableView.sectionFooterHeight = 0.01
        tableView.rowHeight = UITableView.automaticDimension
        
        signUpBtn.setTitle(Localization.text(key: "SignUp"), for: .normal)
        signUpBtn.titleLabel?.font = theme.largeBoldFont
        signUpBtn.setTitleColor(theme.whiteColor, for: .normal)
        let enableImage = UIImage.imageWithGradient(from: theme.blueButtonGradientStartColor, to: theme.blueButtonGradientEndColor, with: signUpBtn.bounds)
        signUpBtn.setBackgroundImage(enableImage, for: .normal)
        signUpBtn.setBackgroundColor(color: .lightGray, forState: .disabled)
        signUpBtn.layer.cornerRadius = theme.cornerRadius
        signUpBtn.layer.masksToBounds = true
        signUpBtn.clipsToBounds = true
    }
}

extension SignUpViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellIdentifier) as? CommonTextFieldCell else {
            return UITableViewCell()
        }
        guard let model = viewModel.dataSource[safe: indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(model: model)
        cell.$textContent
            .sink { text in
                guard let unwrappedText = text else { return }
                
                switch model.modelIndex {
                    
                case .username:
                    self.viewModel.username = unwrappedText
                case .password:
                    self.viewModel.password = unwrappedText
                case .confirmPassword:
                    self.viewModel.confirmPassword = unwrappedText
                case .company:
                    self.viewModel.company = unwrappedText
                case .phone:
                    self.viewModel.phone = unwrappedText
                }
            }
            .store(in: &cancellables)
        return cell
    }
}

extension SignUpViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension CommonTextFieldCell {
    public func configure(model: SignUpCellModel) {
        self.configure(title: model.title, content: model.content)
    }
}
