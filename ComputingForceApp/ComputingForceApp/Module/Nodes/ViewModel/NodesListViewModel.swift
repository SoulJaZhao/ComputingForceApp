//
//  NodesListViewModel.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/2/5.
//

import UIKit
import Combine

class NodesListViewModel: BaseViewModel {
    
    enum RefreshHeaderEvent {
        case start
        case stop
    }
    
    override func getXibName() -> String {
        return "NodesListViewController"
    }
    
    var tabbarItem: UITabBarItem {
        let item = UITabBarItem(title: Localization.text(key: "Nodes"), image: UIImage.init(systemName: "book"), selectedImage: UIImage.init(systemName: "book.fill"))
        return item
    }
    
    let nodesService = NodesService()
    let cellIdentifier = "NodesListCell"
    private var cancellables = Set<AnyCancellable>()
    
    private var refreshHeaderSubject = PassthroughSubject<RefreshHeaderEvent, Never>()
    lazy var refreHeaderPublisher: AnyPublisher<RefreshHeaderEvent, Never> = {
        return refreshHeaderSubject.eraseToAnyPublisher()
    }()
    
    public var nodes: [CityNode] = []
    
    func startFetchingData() {
        if AppContext.context.dependencyInjection.container.resolve(CredentialService.self)?.isLoggedIn == false || nodes.count > 0 {
            return
        }
        refreshHeaderSubject.send(.start)
    }
    
    func fetchNodesForEachCity() {
        nodesService.fetchSummuryForEachCity()
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.refreshHeaderSubject.send(.stop)
                switch completion {
                case .failure:
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
