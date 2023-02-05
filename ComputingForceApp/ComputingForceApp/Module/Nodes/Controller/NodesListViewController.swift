//
//  NodesListViewController.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/2/5.
//

import UIKit
import Combine
import MJRefresh

class NodesListViewController: BaseViewController<NodesListViewModel> {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.startFetchingData()
    }
    
    override func bind(viewModel: NodesListViewModel, storeBindingsIn cancellables: inout Set<AnyCancellable>) {
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
                case .genericAlert:
                    self.showGenericErrorAlert()
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        self.navigationItem.title = Localization.text(key: "Nodes")
        
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
}

extension NodesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.nodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellIdentifier) as? NodesListCell else {
            return UITableViewCell()
        }
        guard let node = viewModel.nodes[safe: indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(city: node.name, count: node.count)
        return cell
    }
}

extension NodesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

