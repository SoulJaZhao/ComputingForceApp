//
//  AddCityNodeViewController.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/2/8.
//

import UIKit
import Combine

class AddCityNodeViewController: BaseViewController<AddCityNodeViewModel> {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var cancellables = Set<AnyCancellable>()
    
    var addAttributeButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        self.title = Localization.text(key: "AddingCity")
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: Localization.text(key: "Close"), style: .plain, target: self, action: #selector(close))
        self.navigationItem.leftBarButtonItem?.tintColor = .red
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Localization.text(key: "Done"), style: .plain, target: self, action: #selector(addCityNode))
        
        
        let nib = UINib(nibName: viewModel.dataSource.cellIdentifier, bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: viewModel.dataSource.cellIdentifier)
        tableView.estimatedRowHeight = 180
        tableView.sectionHeaderHeight = 0.01
        tableView.sectionFooterHeight = 0.01
        tableView.rowHeight = UITableView.automaticDimension
        
        addAttributeButton = UIButton(type: .contactAdd)
        addAttributeButton?.controlEventPublisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                let result = self.viewModel.addRowViewModel()
                if (result == false) {
                    self.showGenericErrorAlert()
                }
            })
            .store(in: &cancellables)
    }
    
    override func bind(viewModel: AddCityNodeViewModel, storeBindingsIn cancellables: inout Set<AnyCancellable>) {
        super.bind(viewModel: viewModel, storeBindingsIn: &cancellables)
        
        viewModel.loadingEventSubject
            .receive(on: RunLoop.main)
            .sink { event in
                switch event {
                case .on:
                    self.startLoading()
                case .off:
                    self.stopLoading()
                }
            }
            .store(in: &cancellables)
        
        viewModel.alertEventSubject
            .receive(on: RunLoop.main)
            .sink { event in
                switch event {
                case .genericErrorAlert:
                    self.showGenericErrorAlert()
                case .genericSuccessAlert:
                    self.showGenericSuccessAlert {
                        self.dismiss(animated: true) {
                            viewModel.delegate?.didAddCityNode()
                        }
                    }
                }
            }
            .store(in: &cancellables)
        
        viewModel.dataSource.attributeSection.$rowViewModels
            .receive(on: RunLoop.main)
            .sink { rows in
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.isAddCityNodeEnablePublisher
            .receive(on: RunLoop.main)
            .sink { isValidate in
                if isValidate {
                    self.navigationItem.rightBarButtonItem?.tintColor = UIColor.navigationBatItemColor
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                } else {
                    self.navigationItem.rightBarButtonItem?.tintColor = UIColor.navigationBatItemDisabledColor
                    self.navigationItem.rightBarButtonItem?.isEnabled = false
                }
            }
            .store(in: &cancellables)
    }
    
    @objc func close() {
        self.view.endEditing(true)
        self.dismiss(animated: true)
    }
    
    @objc func addCityNode() {
        self.view.endEditing(true)
        viewModel.requestAddCityNode()
    }
}

extension AddCityNodeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.dataSource.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.dataSource.sectionViewModels[safe: section]?.sectionType.sectionTitle
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.sectionViewModels[safe: section]?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.dataSource.cellIdentifier) as? TextFieldsCell else {
            return UITableViewCell()
        }
        guard let sectionViewModel = viewModel.dataSource.sectionViewModels[safe: indexPath.section] else {
            return UITableViewCell()
        }
        
        switch sectionViewModel.sectionType {
        case .province:
            cell.configure(mode: .primary, primaryContent: viewModel.province, secondaryContent: nil, primaryPlaceholder: Localization.text(key: "Province"))
            cell.primaryTextField.textPublisher
                .receive(on: RunLoop.main)
                .sink { content in
                    self.viewModel.province = content
                    self.viewModel.cityNodeChangedSubject.send()
                }
                .store(in: &cancellables)
        case .city:
            cell.configure(mode: .primary, primaryContent: viewModel.city, secondaryContent: nil, primaryPlaceholder: Localization.text(key: "City"))
            cell.primaryTextField.textPublisher
                .receive(on: RunLoop.main)
                .sink { content in
                    self.viewModel.city = content
                    self.viewModel.cityNodeChangedSubject.send()
                }
                .store(in: &cancellables)
        case .attribute:
            let rowViewModel = sectionViewModel.rowViewModels[safe: indexPath.row]
            cell.configure(mode: .both, primaryContent: rowViewModel?.key, secondaryContent: rowViewModel?.value, primaryPlaceholder: Localization.text(key: "Key"), secondaryPlaceholder: Localization.text(key: "Value"))
            cell.primaryTextField.textPublisher
                .receive(on: RunLoop.main)
                .sink { content in
                    rowViewModel?.key = content
                    self.viewModel.cityNodeChangedSubject.send()
                }
                .store(in: &cancellables)
            cell.secondaryTextField.textPublisher
                .receive(on: RunLoop.main)
                .sink { content in
                    rowViewModel?.value = content
                    self.viewModel.cityNodeChangedSubject.send()
                }
                .store(in: &cancellables)
            
        }
        
        return cell
    }
}

extension AddCityNodeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if viewModel.dataSource.sectionViewModels[safe: section]?.sectionType == .attribute {
            return addAttributeButton
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if viewModel.dataSource.sectionViewModels[safe: section]?.sectionType == .attribute {
            return 44
        } else {
            return 0.01
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
