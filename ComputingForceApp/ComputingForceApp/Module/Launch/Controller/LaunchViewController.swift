//
//  LaunchViewController.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/13.
//

import UIKit
import Combine

class LaunchViewController: BaseViewController<LaunchViewModel> {
    @IBOutlet weak var skipBtn: UIButton!
    
    private var cancellables = Set<AnyCancellable>()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Published private var currentSkipTime: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        currentSkipTime = 0
        let start = Date()
        timer
            .map { output in
                return output.timeIntervalSince(start)
            }
            .map{ (timeInterval) in
                return Int(timeInterval)
            }
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.currentSkipTime += 1
                self.updateBtnTime()
            }
            .store(in: &cancellables)
    }
    
    open override func bind(viewModel: LaunchViewModel, storeBindingsIn cancellables: inout Set<AnyCancellable>) {
        
        viewModel.transitionEvent
            .sink { route in
                if case .mainView = route {
                    AppContext.context.router.transitionEvent.send(.mainView)
                }
            }
            .store(in: &cancellables)
        
        $currentSkipTime
            .sink { [weak self] value in
                guard let self = self else { return }
                if value == self.viewModel.skipTime {
                    self.redirectToMainView()
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        skipBtn.titleLabel?.font = AppContext.context.theme.smallFont
        updateBtnTime()
        skipBtn.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.redirectToMainView()
            }
            .store(in: &cancellables)
    }
    
    private func updateBtnTime() {
        skipBtn.setTitle((Localization.text(key: "Skip") ?? "") + "\(viewModel.skipTime - currentSkipTime)", for: .normal)
    }
    
    private func redirectToMainView() {
        timer.upstream.connect().cancel()
        self.viewModel.transitionEvent.send(.mainView)
    }
}
