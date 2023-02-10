//
//  NodeViewController.swift
//  ComputingForceApp
//
//  Created by Long Zhao on 2023/2/10.
//

import UIKit

class NodeViewController: BaseViewController<NodeViewModel> {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        self.title = viewModel.node.properties?.name
            
        let nib = UINib(nibName: viewModel.cellIdentifier, bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: viewModel.cellIdentifier)
        tableView.estimatedRowHeight = 180
        tableView.sectionHeaderHeight = 0.01
        tableView.sectionFooterHeight = 0.01
        tableView.rowHeight = UITableView.automaticDimension
    }
}

extension NodeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeader(section: section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellIdentifier) as? NodeCell else {
            return UITableViewCell()
        }
        
        let section = NodeViewModel.SectionType(rawValue: indexPath.section)
        switch section {
        case .nodeID:
            cell.configure(title: String(viewModel.node.nodeID ?? 0), description: nil)
        case .elementID:
            cell.configure(title: viewModel.node.elementId, description: nil)
        case .labels:
            let labels = viewModel.node.labels?.joined(separator: ",")
            cell.configure(title: labels, description: nil)
        case .properties:
            let row = NodeViewModel.PropertyRowType(rawValue: indexPath.row)
            switch row {
            case .gpu:
                cell.configure(title: Localization.text(key: "GPU"), description: viewModel.node.properties?.GPU)
            case .cpu:
                cell.configure(title: Localization.text(key: "CPU"), description: viewModel.node.properties?.CPU)
            case .extData:
                cell.configure(title: Localization.text(key: "ExtData"), description: viewModel.node.properties?.extData)
            case .hardDisk:
                cell.configure(title: Localization.text(key: "HardDisk"), description: viewModel.node.properties?.harddisk)
            case .memory:
                cell.configure(title: Localization.text(key: "Memory"), description: viewModel.node.properties?.memory)
            case .ip:
                cell.configure(title: Localization.text(key: "IP"), description: viewModel.node.properties?.IP)
            case .os:
                cell.configure(title: Localization.text(key: "OS"), description: viewModel.node.properties?.OS)
            case .name:
                cell.configure(title: Localization.text(key: "Name"), description: viewModel.node.properties?.name)
            case .none:
                break
            }
        default:
            break
        }
        
        return cell
    }
}

extension NodeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
