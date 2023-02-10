//
//  CityNodeListViewController.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/2/5.
//

import UIKit
import Combine
import MJRefresh

class CityNodeListViewController: BaseViewController<CityNodeListViewModel> {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.startFetchingData()
    }
    
    private func setupUI() {
        self.title = viewModel.cityNode.name
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.viewModel.fetchNodesForEachCity()
        })
        
        let nib = UINib(nibName: viewModel.cellIdentifier, bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: viewModel.cellIdentifier)
        tableView.estimatedRowHeight = 180
        tableView.sectionHeaderHeight = 0.01
        tableView.sectionFooterHeight = 0.01
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func bind(viewModel: CityNodeListViewModel, storeBindingsIn cancellables: inout Set<AnyCancellable>) {
        super.bind(viewModel: viewModel, storeBindingsIn: &cancellables)
        viewModel.refreHeaderPublisher
            .receive(on: RunLoop.main)
            .sink { event in
                switch event {
                case .start:
                    self.tableView.isUserInteractionEnabled = false
                    self.tableView.mj_header?.beginRefreshing()
                case .stop:
                    self.tableView.isUserInteractionEnabled = true
                    self.tableView.mj_header?.endRefreshing()
                    self.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
        
        viewModel.alertEventSubject
            .sink { event in
                switch event {
                case .genericErrorAlert:
                    self.showGenericErrorAlert()
                case .genericSuccessAlert:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

extension CityNodeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.nodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellIdentifier) as? CityNodeListCell else {
            return UITableViewCell()
        }
        guard let node = viewModel.nodes[safe: indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(node: node)
        return cell
    }
}

extension CityNodeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let node = viewModel.nodes[safe: indexPath.row] else {
            return
        }
        let viewController = viewModel.getNodeViewController(node: node)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
