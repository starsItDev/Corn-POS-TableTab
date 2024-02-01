//
//  Constants.swift
//  Corn Tab
//
//  Created by StarsDev on 21/07/2023.
//

import Foundation

struct APIConstants {
    static let baseURL = "https://jhh3bgjqhj.execute-api.ap-southeast-1.amazonaws.com/Prod"
    
    struct Endpoints {
        static let getPin = "/MultiTenant/GetClientInfo"
        static let login = "/token"
        static let dashBoard = "/Common/ExecSp/"
        static let masterDetail = "/Common/ExecSp/"
        
    }
}


















//
//import UIKit
//
//class SelectionVC: UIViewController {
//    // MARK: Outlets
//    @IBOutlet weak var segments: UISegmentedControl!
//    @IBOutlet weak var collectionView: UICollectionView!
//    @IBOutlet weak var searchField: UITextField!
//    @IBOutlet weak var itemCountTxt: UITextField!
//
//    let textFieldDelegateHelper = TextFieldDelegateHelper()
//    var itemCount: Int = 0
//    var segmentIndexPathMapping: [Int: IndexPath] = [:] // Dictionary to map segment index to collection view index path
//
//    // MARK: View Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let boldFont = UIFont.boldSystemFont(ofSize: 20)
//        let attributes = [NSAttributedString.Key.font: boldFont]
//
//        segments.setTitleTextAttributes(attributes, for: .normal)
//        textFieldDelegateHelper.configureTapGesture(for: view)
//        searchField.delegate = textFieldDelegateHelper
//        itemCountTxt.delegate = textFieldDelegateHelper
//        itemCountTxt.text = "0" // Set initial text field value to "0"
//    }
//
//    // MARK: Actions
//    @IBAction func minusButton(_ sender: UIButton) {
//        if let itemCountText = itemCountTxt.text, let itemCountValue = Int(itemCountText) {
//            let newValue = max(0, itemCountValue - 1)
//            itemCountTxt.text = String(newValue)
//        }
//    }
//    @IBAction func plusButton(_ sender: UIButton) {
//        if let itemCountText = itemCountTxt.text, let itemCountValue = Int(itemCountText) {
//            let newValue = itemCountValue + 1
//            itemCountTxt.text = String(newValue)
//        }
//    }
//    @IBAction func segmentController(_ sender: UISegmentedControl) {
//        collectionView.reloadData()
//    }
//}
////MARK: Collection View
//extension SelectionVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 100
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SelectionCVCell
//
//        if let selectedIndexPath = segmentIndexPathMapping[segments.selectedSegmentIndex], selectedIndexPath == indexPath {
//            cell.cellView.backgroundColor = #colorLiteral(red: 0.8596192002, green: 0.3426481783, blue: 0.2044148147, alpha: 1)
//        } else {
//            cell.cellView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        }
//        return cell
//    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        segmentIndexPathMapping[segments.selectedSegmentIndex] = indexPath
//        collectionView.reloadData()
//    }
//}
