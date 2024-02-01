//
//  DashboardVC.swift
//  Corn Tab
//
//  Created by StarsDev on 12/07/2023.

import UIKit

class DashboardVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            if let tabBarController = self.tabBarController {
                // Set the index of the tab you want to select
                tabBarController.selectedIndex = 2
                UserDefaults.standard.removeObject(forKey: "TableContent")

            }
        }
    }
}

