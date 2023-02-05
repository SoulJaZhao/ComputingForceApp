//
//  NodesListCell.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/2/5.
//

import UIKit

class NodesListCell: UITableViewCell {
    
    @IBOutlet var cityNameLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(city: String, count: Int) {
        cityNameLabel.text = city
        let nodesNumberText: String = Localization.text(key: "NodesNumber") ?? ""
        countLabel.text = "\(nodesNumberText):\(count)"
    }
    
}
