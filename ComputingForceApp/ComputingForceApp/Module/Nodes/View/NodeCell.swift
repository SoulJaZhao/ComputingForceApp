//
//  NodeCell.swift
//  ComputingForceApp
//
//  Created by Long Zhao on 2023/2/10.
//

import UIKit

class NodeCell: UITableViewCell {
    @IBOutlet weak var primaryLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(title: String?, description: String?) {
        if let unwrappedTitle = title {
            primaryLabel.text = unwrappedTitle
            primaryLabel.isHidden = false
        } else {
            primaryLabel.text = nil
            primaryLabel.isHidden = true
        }
        
        if let unwrappedDescription = description {
            descriptionLabel.text = unwrappedDescription
            descriptionLabel.isHidden = false
        } else {
            descriptionLabel.text = nil
            descriptionLabel.isHidden = true
        }
    }
}
