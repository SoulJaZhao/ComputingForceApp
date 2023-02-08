//
//  CityNodeListViewModel.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/2/5.
//

import Foundation
import Combine

class CityNodeListViewModel: BaseViewModel {
    
    override func getXibName() -> String {
        return "CityNodeListViewController"
    }
    
    let nodesService = NodesService()
    let cellIdentifier = "CityNodeListCell"
    private var cancellables = Set<AnyCancellable>()
    
    private var refreshHeaderSubject = PassthroughSubject<RefreshHeaderEvent, Never>()
    lazy var refreHeaderPublisher: AnyPublisher<RefreshHeaderEvent, Never> = {
        return refreshHeaderSubject.eraseToAnyPublisher()
    }()
    
    let cityNode: CityNode
    
    var nodes: [Node] = []
    
    init(cityNode: CityNode) {
        self.cityNode = cityNode
        super.init()
    }
    
    func startFetchingData() {
        refreshHeaderSubject.send(.start)
    }
    
    func fetchNodesForEachCity() {
        nodesService.fetchNodes(cityNode: self.cityNode)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.refreshHeaderSubject.send(.stop)
                switch completion {
                case .failure(let error):
                    print(error)
                    self.alertEventSubject.send(.genericAlert)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] data in
                guard let self = self else { return }
                self.nodes = data
            }
            .store(in: &cancellables)
    }
}
