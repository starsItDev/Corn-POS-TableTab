//
//  DealsCVCell.swift
//  Corn Tab
//
//  Created by StarsDev on 11/10/2023.
//

import UIKit

class DealsCVCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var imagePath: UIImageView!
    @IBOutlet weak var qtyLbl: UILabel!
    
    var itemId: Int?
}
