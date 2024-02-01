//
//  SelectionTVCell.swift
//  Corn Tab
//
//  Created by StarsDev on 29/11/2023.
//
import Foundation
import UIKit

class SelectionTVCell: UITableViewCell {
    
        
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var addressLbl: UILabel!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var phoneLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
