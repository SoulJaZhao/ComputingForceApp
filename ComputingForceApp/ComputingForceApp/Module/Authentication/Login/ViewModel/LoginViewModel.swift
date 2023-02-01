//
//  LoginViewModel.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/12.
//

import Foundation
import Combine

class LoginViewModel: BaseViewModel {
    
    @Published var isRemeberMe = true
    @Published var username: String = ""
    @Published var password: String = ""
    
    let authenticationService = AuthenticationService()
    let keychainService: KeychainServiceProtocol? = AppContext.context.dependencyInjection.container.resolve(KeychainServiceProtocol.self)
    
    private var cancellables = Set<AnyCancellable>()
    
    override func getXibName() -> String {
        return "LoginViewController"
    }
    
    func login() {
        loadingEventSubject.send(.on)
        authenticationService.login(username: username, password: password)
            .receive(on: RunLoop.main)
            .sink { [weak self] completeion in
                guard let self = self else { return }
                switch completeion {
                case .finished:
                    if self.isRemeberMe == true {
                        self.storeKeychain(username: self.username, password: self.password)
                    } else {
                        self.keychainService?.removeAll()
                    }
                    self.loadingEventSubject.send(.off)
                case .failure(_):
                    self.loadingEventSubject.send(.off)
                    self.alertEventSubject.send(.genericAlert)
                }
            } receiveValue: { user in
                print(user)
            }
            .store(in: &cancellables)

    }
    
    func storeKeychain(username: String, password: String) {
        self.keychainService?.store(username: username, password: password)
    }
    
    func getStoredData() -> (username: String?, password: String?) {
        return keychainService?.getUsernameAndPassword() ?? (nil, nil
    )
    }
}
