//
//  OrderDetailsTVCell.swift
//  Corn Tab
//
//  Created by StarsDev on 13/07/2023.
//

import UIKit

class OrderDetailsTVCell: UITableViewCell {

    @IBOutlet weak var deleteCellBtn: UIButton!
    @IBOutlet weak var plusbtn: UIButton!
    @IBOutlet weak var minBtn: UIButton!
    @IBOutlet weak var itemCountLbl: UILabel!
    @IBOutlet weak var eidtBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var addOnItemDLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    var itemCount = 0 {
           didSet {
               itemCountLbl.text = "\(itemCount)"
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
