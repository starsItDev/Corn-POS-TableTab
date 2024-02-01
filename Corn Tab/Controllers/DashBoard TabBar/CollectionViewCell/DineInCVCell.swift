//
//  DineInCVCell.swift
//  Corn Tab
//
//  Created by StarsDev on 14/07/2023.
//

import UIKit

class DineInCVCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var imagePath: UIImageView!
    @IBOutlet weak var qtyLbl: UILabel!
    
    var itemId: Int?
}
