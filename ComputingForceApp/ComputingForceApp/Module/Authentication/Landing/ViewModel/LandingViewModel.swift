//
//  LandingViewModel.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/10.
//

import Foundation
import Combine

class LandingViewModel: BaseViewModel {
    
    override func getXibName() -> String {
        return "LandingViewController"
    }
    
    enum Transition {
        case signIn
        case signUp
    }
    
    enum ViewOutputEvent {
        case transition(Transition)
    }
    
    private var subscriptions = Set<AnyCancellable>()
    private let transitionSubject: PassthroughSubject = PassthroughSubject<Transition, Never>()
    public lazy var transitionPublisher: AnyPublisher<Transition, Never> = transitionSubject.eraseToAnyPublisher()
    public let viewOutputSubject: PassthroughSubject<ViewOutputEvent, Never> = PassthroughSubject()
    
    override init() {
        super.init()
        
        viewOutputSubject
            .sink { [weak self] event in
                guard let self = self else { return }
                if case .transition(let destination) = event {
                    switch destination {
                    case .signIn:
                        self.transitionSubject.send(.signIn)
                    case .signUp:
                        self.transitionSubject.send(.signUp)
                    }
                }
            }
            .store(in: &subscriptions)
    }
}
