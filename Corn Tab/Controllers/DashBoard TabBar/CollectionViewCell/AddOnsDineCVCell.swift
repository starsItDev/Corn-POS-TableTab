//
//  AddOnsDineCVCell.swift
//  Corn Tab
//
//  Created by StarsDev on 29/08/2023.
//

import UIKit
protocol DineInCVCellDelegate: AnyObject {
    func addToOrderButtonTapped(itemName: String, priceAddOn: String, quantity: String, price: String)
}

class AddOnsDineCVCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    var itemId: Int?
        var addOnId: Int?
}
