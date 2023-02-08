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
        
        viewModel.dataSource.attributeSection.$rowViewModels
            .receive(on: RunLoop.main)
            .sink { rows in
                self.2tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @objc func close() {
        self.dismiss(animated: true)
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
            cell.$primaryContent
                .sink { content in
                    self.viewModel.province = content
                }
                .store(in: &cancellables)
        case .city:
            cell.configure(mode: .primary, primaryContent: viewModel.city, secondaryContent: nil, primaryPlaceholder: Localization.text(key: "City"))
            cell.$primaryContent
                .sink { content in
                    self.viewModel.city = content
                }
                .store(in: &cancellables)
        case .attribute:
            let rowViewModel = sectionViewModel.rowViewModels[safe: indexPath.row]
            cell.configure(mode: .both, primaryContent: rowViewModel?.key, secondaryContent: rowViewModel?.value, primaryPlaceholder: Localization.text(key: "Key"), secondaryPlaceholder: Localization.text(key: "Value"))
            cell.$primaryContent
                .sink { content in
                    rowViewModel?.key = content
                }
                .store(in: &cancellables)
            cell.$secondaryContent
                .sink { content in
                    rowViewModel?.value = content
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
