//
//  AlertViewController.swift
//  Corn Tab
//
//  Created by StarsDev on 18/07/2023.
//

import Foundation
import UIKit
extension UIViewController {
    func showAlert(title: String?,
                   message: String?,
                   preferredStyle: UIAlertController.Style = .alert,
                   actions: [UIAlertAction] = [],
                   completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        actions.forEach { alertController.addAction($0) }
        
        if actions.isEmpty {
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
        }
        
        present(alertController, animated: true, completion: completion)
    }
}



import Foundation
import UIKit

class GradientView1: UIView {

    @IBInspectable var startColor: UIColor = .white {
        didSet {
            updateGradient()
        }
    }
    
    @IBInspectable var endColor: UIColor = .black {
        didSet {
            updateGradient()
        }
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    private func updateGradient() {
        guard let layer = self.layer as? CAGradientLayer else { return }
        layer.colors = [startColor.cgColor, endColor.cgColor]
    }
}

