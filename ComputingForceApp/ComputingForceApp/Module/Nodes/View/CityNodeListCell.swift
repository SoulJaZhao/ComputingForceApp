//
//  CityNodeListCell.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/2/6.
//

import UIKit

class CityNodeListCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cpuLabel: UILabel!
    @IBOutlet weak var gpuLabel: UILabel!
    @IBOutlet weak var memoryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(node: Node) {
        nameLabel.text = node.properties?.name
        cpuLabel.text = "CPU: " + (node.properties?.CPU ?? "")
        gpuLabel.text = "GPU: " + (node.properties?.GPU ?? "")
        memoryLabel.text = "Memory: " + (node.properties?.memory ?? "")
    }
    
}
