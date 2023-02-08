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
    var keychainService: KeychainServiceProtocol? {
        AppContext.context.dependencyInjection.container.resolve(KeychainServiceProtocol.self)
    }
    
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
                    AppContext.context.dependencyInjection.container.resolve(CredentialService.self)?.clear()
                    #warning("Need remove")
                    let user = User.init(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MDQ4NTQwNzYsImlhdCI6MTY3MzMxODA3NiwibmJmIjoxNjczMzE4MDc2LCJzdWIiOiIxLDEifQ.2cZIXujUsgbyB0uiz0pOOlRyiRqklF2EFwiD189CEfg")
                    AppContext.context.dependencyInjection.container.resolve(CredentialService.self)?.set(user: user)
                    self.loadingEventSubject.send(.off)
                    self.alertEventSubject.send(.genericAlert)
                }
            } receiveValue: { user in
                AppContext.context.dependencyInjection.container.resolve(CredentialService.self)?.set(user: user)
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
