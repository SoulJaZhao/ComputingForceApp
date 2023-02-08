//
//  AddCityNodeViewModel.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/2/8.
//

import Foundation
import Combine

class AddCityNodeViewModel: BaseViewModel {
    
    enum SectionType: CaseIterable {
        case province
        case city
        case attribute
        
        var sectionTitle: String? {
            switch self {
            case .province:
                return Localization.text(key: "Province")
            case .city:
                return Localization.text(key: "City")
            case .attribute:
                return Localization.text(key: "Attribute")
            }
        }
    }
    
    @Published var province: String?
    @Published var city: String?
    @Published var attributes:[AddCityNodeRowViewModel] = []
    
    
    override func getXibName() -> String {
        return "AddCityNodeViewController"
    }
    
    let nodesService = NodesService()
    private var cancellables = Set<AnyCancellable>()
    
    let dataSource = AddCityDataSource()
    
    override init() {
        super.init()
        attributes = dataSource.attributeSection.rowViewModels
    }
}

final class AddCityDataSource {
    let cellIdentifier: String = "TextFieldsCell"
    
    private(set) var sectionViewModels: [AddCityNodeSectionViewModel] = []
    let attributeSection: AddCityNodeSectionViewModel
    
    init() {
        let provinceSection = AddCityNodeSectionViewModel(sectionType: .province)
        let citySection = AddCityNodeSectionViewModel(sectionType: .city)
        attributeSection = AddCityNodeSectionViewModel(sectionType: .attribute)
        sectionViewModels = [provinceSection, citySection, attributeSection]
    }
    
    func numberOfSections() -> Int {
        return sectionViewModels.count
    }
}

final class AddCityNodeSectionViewModel {
    let sectionType: AddCityNodeViewModel.SectionType
    
    var rowViewModels: [AddCityNodeRowViewModel] = []
    
    init(sectionType: AddCityNodeViewModel.SectionType) {
        self.sectionType = sectionType
        
        switch sectionType {
        case .attribute:
            let defaultRowViewModel = AddCityNodeRowViewModel()
            rowViewModels = [defaultRowViewModel]
        default:
             break
        }
    }
    
    func numberOfRows() -> Int {
        switch sectionType {
        case .province, .city:
            return 1
        case .attribute:
            return rowViewModels.count
        }
    }
    
    func configure(rows: [AddCityNodeRowViewModel]) {
        self.rowViewModels = rows
    }
}

final class AddCityNodeRowViewModel {
    var key: String?
    var value: String?
    init(key: String? = nil, value: String? = nil) {
        self.key = key
        self.value = value
    }
}
