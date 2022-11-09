//
//  TestCell.swift
//  CleanArch
//
//  Created by HU Siwei on 2020/5/31.
//

import Foundation
import UIKit

final class TestCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        infoLabel.font = UIFont.systemFont(ofSize: 10)
        titleLabel.textColor = .black
        infoLabel.textColor = .gray
    }
}
