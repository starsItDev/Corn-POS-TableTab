//
//  TabBarTVCell.swift
//  Corn Tab
//
//  Created by StarsDev on 17/07/2023.
//

import UIKit

class TabBarTVCell: UITableViewCell {
    @IBOutlet weak var tableNoLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var orderNoLbl: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var tableLbl: UILabel!
    @IBOutlet weak var cellView: UIView!{
        didSet {
            cellView.layer.borderWidth = 1.0
            cellView.layer.borderColor = #colorLiteral(red: 0.8596192002, green: 0.3426481783, blue: 0.2044148147, alpha: 1)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
