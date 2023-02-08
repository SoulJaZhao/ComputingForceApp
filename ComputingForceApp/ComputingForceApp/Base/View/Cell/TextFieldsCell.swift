//
//  TextFieldsCell.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/2/8.
//

import UIKit
import Combine
import CombineCocoa

class TextFieldsCell: UITableViewCell {
    @IBOutlet weak var primaryTextField: UITextField!
    @IBOutlet weak var secondaryTextField: UITextField!
    
    enum DisplayMode {
        case primary
        case secondary
        case both
    }
    
    @Published var primaryContent: String?
    @Published var secondaryContent: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        primaryTextField.textPublisher
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] text in
                guard let self = self else { return }
                self.primaryContent = text
            }
            .store(in: &cancellables)
        
        secondaryTextField.textPublisher
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] text in
                guard let self = self else { return }
                self.secondaryContent = text
            }
            .store(in: &cancellables)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(mode: TextFieldsCell.DisplayMode,
                          primaryContent: String?,
                          secondaryContent: String?,
                          primaryPlaceholder: String? = nil,
                          secondaryPlaceholder: String? = nil) {
        
        switch mode {
        case .primary:
            primaryTextField.isHidden = false
            secondaryTextField.isHidden = true
        case .secondary:
            primaryTextField.isHidden = true
            secondaryTextField.isHidden = false
        case .both:
            primaryTextField.isHidden = false
            secondaryTextField.isHidden = false
        }
        
        primaryTextField.text = primaryContent
        self.primaryContent = primaryContent
        primaryTextField.placeholder = primaryPlaceholder
        
        secondaryTextField.text = secondaryContent
        self.secondaryContent = secondaryContent
        secondaryTextField.placeholder = secondaryPlaceholder
    }
    
}
