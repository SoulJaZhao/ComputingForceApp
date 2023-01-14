//
//  CommonTextFieldCell.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/14.
//

import UIKit
import Combine

class CommonTextFieldCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldContainerView: UIView!
    
    @Published var textContent: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let theme = AppContext.context.theme
        
        contentView.backgroundColor = theme.backggroundColor
        textFieldContainerView.backgroundColor = theme.backggroundColor
        
        titleLabel.font = theme.mediumFont
        titleLabel.textColor = theme.darkLabelTitleColor
        
        textFieldContainerView.layer.borderColor = theme.textfieldBorderColor.cgColor
        textFieldContainerView.layer.borderWidth = 1.5
        textFieldContainerView.layer.cornerRadius = theme.cornerRadius
        textFieldContainerView.layer.masksToBounds = true
        textFieldContainerView.clipsToBounds = true
        
        textField.textPublisher
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] text in
                guard let self = self else { return }
                self.textContent = text
            }
            .store(in: &cancellables)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(title: String?, content: String?) {
        titleLabel.text = title
        textField.text = content
        textField.placeholder = title
    }
    
}
