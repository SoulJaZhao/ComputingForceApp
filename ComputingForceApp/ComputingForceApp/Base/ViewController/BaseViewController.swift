//
//  BaseViewController.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/10.
//

import UIKit
import Combine

class BaseViewController<ViewModelType: BaseViewModel>: UIViewController {
    
    let viewModel: ViewModelType
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel:ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: viewModel.getXibName(), bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(viewModel: viewModel, storeBindingsIn: &cancellables)
    }
    
    /// Entry point for data binding in both `view to viewModel` and `viewModel to view` directions.
    open func bind(viewModel: ViewModelType, storeBindingsIn cancellables: inout Set<AnyCancellable>) {
    }
}
