//
//  UIImage+KingFisher.swift
//  Corn Tab
//
//  Created by StarsDev on 28/08/2023.
//


import Foundation
import Kingfisher
import UIKit

extension UIImageView {
    func setImage(with urlString: String) {
        guard let url = URL.init(string: urlString) else {
            return
        }
        let resource = KF.ImageResource(downloadURL: url, cacheKey: urlString)
        kf.indicatorType = .activity
        kf.setImage(with: resource)
    }
}
