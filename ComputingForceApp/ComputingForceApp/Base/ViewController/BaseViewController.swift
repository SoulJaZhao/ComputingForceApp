//
//  BaseViewController.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/10.
//

import UIKit

class BaseViewController<ViewModelType: BaseViewModel>: UIViewController {
    
    let viewModel: ViewModelType
    
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

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
