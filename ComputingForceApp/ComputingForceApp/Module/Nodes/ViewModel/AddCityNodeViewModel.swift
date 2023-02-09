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
    
    let cityNodeChangedSubject: PassthroughSubject<Void, Never> = PassthroughSubject()
    lazy var isAddCityNodeEnablePublisher: AnyPublisher<Bool, Never> = {
        cityNodeChangedSubject
            .map { [weak self] in
                guard let self = self, let city = self.city, let province = self.province else { return false }
                if (city.isEmpty || province.isEmpty) {
                    return false
                }
                return self.canAddRowViewModel()
            }
            .eraseToAnyPublisher()
        
    }()
    
    override func getXibName() -> String {
        return "AddCityNodeViewController"
    }
    
    let nodesService = NodesService()
    private var cancellables = Set<AnyCancellable>()
    
    let dataSource = AddCityDataSource()
    
    override init() {
        super.init()
    }
    
    func addRowViewModel() -> Bool {
        if canAddRowViewModel() == false {
            return false
        } else {
            let rowViewModel = AddCityNodeRowViewModel()
            dataSource.attributeSection.rowViewModels.append(rowViewModel)
            return true
        }
    }
    
    private func canAddRowViewModel() -> Bool {
        var isValidate = true
        dataSource.attributeSection.rowViewModels.forEach { row in
            if let key = row.key, let value = row.value {
                if (key.isEmpty || value.isEmpty) {
                    isValidate = false
                }
            } else {
                isValidate = false
            }
        }
        return isValidate
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
    
    @Published var rowViewModels: [AddCityNodeRowViewModel] = []
    
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
