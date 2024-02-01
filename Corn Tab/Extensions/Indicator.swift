//
//  Indicator.swift
//  Corn Tab
//
//  Created by StarsDev on 21/09/2023.
//

import Foundation
import UIKit
extension UIAlertController {
    func addActivityIndicator() {
        // Hide the alert's content by setting its text to an empty string
        self.message = ""
        self.title = ""

        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()

        view.addSubview(indicator)

        let views: [String: UIView] = ["alert": view, "indicator": indicator]
        var constraints = [NSLayoutConstraint]()

        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "V:[indicator]-(10)-|",
            options: [],
            metrics: nil,
            views: views
        )
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[indicator]|",
            options: [],
            metrics: nil,
            views: views
        )

        view.addConstraints(constraints)
    }
}

//extension UIAlertController {
//    func addActivityIndicator() {
//        let indicator = UIActivityIndicatorView(style: .medium)
//        indicator.translatesAutoresizingMaskIntoConstraints = false
//        indicator.startAnimating()
//
//        view.addSubview(indicator)
//
//        let views: [String: UIView] = ["alert": view, "indicator": indicator]
//        var constraints = [NSLayoutConstraint]()
//
//        constraints += NSLayoutConstraint.constraints(
//            withVisualFormat: "V:[indicator]-(10)-|",
//            options: [],
//            metrics: nil,
//            views: views
//        )
//        constraints += NSLayoutConstraint.constraints(
//            withVisualFormat: "H:|[indicator]|",
//            options: [],
//            metrics: nil,
//            views: views
//        )
//
//        view.addConstraints(constraints)
//    }
//}
//


////  DineInVC.swift
////  Corn Tab
////  Created by Ali Sher on 12/07/2023.
//
//import UIKit
//
//class DineInVC: UIViewController,UITextFieldDelegate{
//    // MARK: Outlets
//    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var segments: UISegmentedControl!
//    @IBOutlet weak var itemViewLbl: UILabel!
//    @IBOutlet weak var subView: UIView!
//    @IBOutlet weak var itemSelectedLbl: UILabel!
//    @IBOutlet weak var subViewLbl: UILabel!
//    @IBOutlet weak var subViewPriceLbl: UILabel!
//    @IBOutlet weak var floorLbl: UILabel!
//    @IBOutlet weak var tableNoLbl: UILabel!
//    @IBOutlet weak var titleLbl: UILabel!
//    @IBOutlet weak var quntityLbl: UILabel!
//    @IBOutlet weak var coverTableLbl: UILabel!
//    @IBOutlet weak var itemcollectionView: UICollectionView!
//    @IBOutlet weak var addOnscollectionView: UICollectionView!
//    // MARK: Properties
//
//    var selectedAddOnName: String?
//    var selectedItemIndexPath: IndexPath?
//
//    var sectionNames: [String] = []
//    var itemIDToSectionID: [Int: Int] = [:]
//    var sectionNameToID: [String: Int] = [:]
//    var selectedAddOnIndexPaths: Set<IndexPath> = []
//
//    var receivedLabelText: String?
//    var receivedSegmentTitle: String?
//    var receivedItemCount: String? = nil
//
//    var selectedItemName: String?
//    var selectedItemPrice: String?
//    var itemCountinCV = 1
//    var itemCount = 0
//    var selectedBtnIndex: Int = 0
////    var selectedItemsCount = 0
//
//    var selectedIndexPaths: [IndexPath] = []
//    var lastSelectedIndexPath: IndexPath?
//    var apiResponse: [MasterDetailRow] = []
//    var apiResponseAddOns: [MasterDetailRow] = []
//    var parsedRows: [[MasterDetailRow]] = []
//    // MARK: View Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        navigationController?.setNavigationBarHidden(true, animated: false)
//        let boldFont = UIFont.boldSystemFont(ofSize: 20)
//        let attributes = [NSAttributedString.Key.font: boldFont]
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        tapGesture.cancelsTouchesInView = false
//        view.addGestureRecognizer(tapGesture)
//        segments.setTitleTextAttributes(attributes, for: .normal)
//        itemcollectionView.delegate = self
//        itemcollectionView.dataSource = self
//        itemcollectionView.reloadData()
//        hideSubView()
//        userDefaults()
//
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        if let labelText = receivedLabelText {
//            tableNoLbl.text = ":\(labelText)"
//        }
//        if let itemCount = receivedItemCount {
//               coverTableLbl.text = "\(itemCount)"
//           }
//        if let segment = receivedSegmentTitle, let text = receivedLabelText {
//            floorLbl.text = "\(segment)\nSelected Text: \(text)"
//        }
//        self.itemcollectionView.reloadData()
//    }
//    // MARK: Actions
//    func userDefaults() {
//        if let savedData = UserDefaults.standard.data(forKey: "parsedDataKey"),
//           let rows = try? JSONDecoder().decode([[MasterDetailRow]].self, from: savedData) {
//            self.parsedRows = rows
//        } else {
//            // Handle the case where no data is saved in UserDefaults
//        }
//        // Move your API response processing logic here
//        var sectionNameToID: [String: Int] = [:]
//        let rowItemData = self.parsedRows[6] // Assuming you want to use data from parsedRows
//        let addOnsItemData = self.parsedRows[7]
//
//        for dashboardModel in self.parsedRows {
//            for row in dashboardModel {
//                if let sectionID = row.categoryID, let sectionName = row.category {
//                    if !sectionNameToID.keys.contains(sectionName) {
//                        sectionNameToID[sectionName] = sectionID
//                        self.sectionNames.append(sectionName)
//                    }
//                    if let itemID = row.itemID {
//                        self.itemIDToSectionID[itemID] = sectionID
//                    }
//                }
//            }
//        }
//        // UI updates can be performed here
//        DispatchQueue.main.async {
//            self.apiResponse = rowItemData
//            self.apiResponseAddOns = addOnsItemData
//            self.segments.removeAllSegments()
//            self.sectionNameToID = sectionNameToID // Clear existing segments
//            for (index, sectionName) in self.sectionNames.enumerated() {
//                self.segments.insertSegment(withTitle: sectionName, at: index, animated: false)
//            }
//            self.segments.selectedSegmentIndex = 0
//            self.itemcollectionView.reloadData()
//            self.addOnscollectionView.reloadData()
//        }
//    }
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//    @IBAction func segmentController(_ sender: UISegmentedControl) {
//        let selectedSegmentIndex = sender.selectedSegmentIndex
//        let segmentWidth = scrollView.contentSize.width / CGFloat(segments.numberOfSegments - 1)
//        var xOffset: CGFloat = 0
//        if selectedSegmentIndex < segments.numberOfSegments - 3 {
//            xOffset = max(0, segmentWidth * CGFloat(selectedSegmentIndex) - 400)
//        } else {
//            xOffset = scrollView.contentSize.width - scrollView.frame.width
//        }
//        scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
//        itemCount = 0
//        updateItemCountLabel()
//        itemcollectionView.reloadData()
//        addOnscollectionView.reloadData()
//        updateCountLabel()
//        selectedIndexPaths.removeAll()
//    }
//    @IBAction func closeButton(_ sender: UIButton) {
//        hideSubView()
//        itemCount = 0
//        updateItemCountLabel()
//        if let lastSelectedIndexPath = lastSelectedIndexPath {
//            // Remove the lastSelectedIndexPath from the common selectedIndexPaths array
//            if let index = selectedIndexPaths.firstIndex(of: lastSelectedIndexPath) {
//                selectedIndexPaths.remove(at: index)
//            }
//            itemcollectionView.reloadItems(at: [lastSelectedIndexPath])
//        }
//        clearSelectedAddOnIndexPaths()
//        addOnscollectionView.reloadData()
//    }
//    @IBAction func addToOrder(_ sender: UIButton) {
//        guard itemCount > 0 else {
//            showAlert(title: "Error", message: "Please select items to add to the order.")
//            return
//        }
//        updateCountLabel()
//        let title = titleLbl.text ?? ""
//        let quantity = quntityLbl.text ?? ""
//        let basePriceText = subViewPriceLbl.text ?? "0.0"
//        let basePrice = Double(basePriceText) ?? 0.0
//        var selectedAddOns: [String] = []
//        var selectedAddOnPrices: [Double] = []
//
//        for indexPath in selectedAddOnIndexPaths {
//            if let cell = addOnscollectionView.cellForItem(at: indexPath) as? AddOnsDineCVCell,
//               let addOnName = cell.nameLabel.text,
//               let addOnPriceText = cell.priceLabel.text,
//               let addOnPrice = Double(addOnPriceText.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
//                let addOnInfo = "\(addOnName) (\(addOnPrice))"
//                selectedAddOns.append(addOnInfo)
//                selectedAddOnPrices.append(addOnPrice)
//            }
//        }
//        let totalAddOnPrice = selectedAddOnPrices.reduce(0, +)
//        let totalPrice = basePrice + totalAddOnPrice
//        let selectedAddOnsString = selectedAddOns.joined(separator: "\n")
//        let titleWithPrice: String
//        if selectedAddOnsString.isEmpty {
//            titleWithPrice = title
//        } else {
//            titleWithPrice = "\(title) - (\(basePriceText))"
//        }
//        let newItem: [String: String] = [
//            "title": titleWithPrice,
//            "quantity": quantity,
//            "price" : "\(totalPrice)",
//            "selectedAddOns": selectedAddOnsString,
//        ]
//        var savedItems = UserDefaults.standard.array(forKey: "addedItems") as? [[String: String]] ?? []
//        savedItems.append(newItem)
//        UserDefaults.standard.set(savedItems, forKey: "addedItems")
//        clearSelectedAddOnIndexPaths()
//        addOnscollectionView.reloadData()
//    }
//    @IBAction func minusButton(_ sender: UIButton) {
//        itemCount = max(0, itemCount - 1)
//        updateItemCountLabel()
//    }
//    @IBAction func plusButton(_ sender: UIButton) {
//        itemCount += 1
//        updateItemCountLabel()
//    }
//    // MARK: Helper Methods
//    func clearSelectedAddOnIndexPaths() {
//        selectedAddOnIndexPaths.removeAll()
//        addOnscollectionView.reloadData()
//    }
//    func updateItemCountLabel() {
//        itemViewLbl.text = String(itemCount)
//    }
//    func showSubView() {
//        subView.isHidden = false
//    }
//    func hideSubView() {
//        subView.isHidden = true
//    }
//    private func updateCountLabel() {
//        let totalCount = selectedIndexPaths.count
////        itemSelectedLbl.text = "\(totalCount)"
//        hideSubView()
//    }
//}
//// MARK: Collection View
//extension DineInVC:  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == itemcollectionView{
//            // Check if the selected segment index is within valid range
//            guard segments.selectedSegmentIndex < sectionNames.count else {
//                // Handle the case where selectedSegmentIndex is out of bounds
//                return 0
//            }
//            let selectedSectionID = sectionNameToID[sectionNames[segments.selectedSegmentIndex]] ?? -1
//            let validItems = apiResponse.filter { item in
//                return item.categoryID == selectedSectionID && item.itemName != nil && item.price != nil && item.imagePath != nil
//            }
//            return validItems.count
//        }else if collectionView == addOnscollectionView {
//            let matchingAddOns = apiResponseAddOns.filter { $0.itemName == selectedItemName && $0.adsOnName != nil
//            }
//            return matchingAddOns.count
//        }
//        return 0
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView == itemcollectionView{
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DineInCVCell
//            guard segments.selectedSegmentIndex < sectionNames.count else {
//                cell.nameLabel?.text = nil
//                cell.priceLabel?.text = nil
//                cell.imagePath?.image = nil
//                return cell
//            }
//            let selectedSectionID = sectionNameToID[sectionNames[segments.selectedSegmentIndex]] ?? -1
//            let validItems = apiResponse.filter { item in
//                return item.categoryID == selectedSectionID && item.itemName != nil && item.price != nil && item.imagePath != nil
//            }
//            // Display item details in the cell
//            if indexPath.row < validItems.count {
//                let item = validItems[indexPath.row]
//                cell.nameLabel?.text = item.itemName
//                if let price = item.price {
//                    cell.priceLabel?.text = "\(price)"
//                }
//                cell.imagePath?.setImage(with: item.imagePath!)
//            } else {
//                cell.nameLabel?.text = nil
//                cell.priceLabel?.text = nil
//                cell.imagePath?.image = nil
//            }
//            return cell
//        }
//        else{
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addOncell", for: indexPath) as! AddOnsDineCVCell
//            if let selectedItemName = selectedItemName {
//                let matchingAddOns = apiResponseAddOns.filter { addOnItem in
//                    return addOnItem.itemName == selectedItemName
//                }
//                if indexPath.row < matchingAddOns.count {
//                    cell.nameLabel.text = matchingAddOns[indexPath.row].adsOnName
//                    if let price = matchingAddOns[indexPath.row].price {
//                        cell.priceLabel.text = "\(price)"
//                    } else {
//                        cell.priceLabel.text = "PKR: N/A"
//                    }
//                }
//            }
//            if selectedAddOnIndexPaths.contains(indexPath) {
//                cell.cellView.backgroundColor = #colorLiteral(red: 0.8596192002, green: 0.3426481783, blue: 0.2044148147, alpha: 1)
//            } else {
//                cell.cellView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//            }
//            return cell
//        }
//    }
//
//    // MARK: UICollectionViewDelegate
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == itemcollectionView {
//            return CGSize(width: UIScreen.main.bounds.width/2 - 50, height: 100)
//        }
//        return CGSize(width: 175, height: 85)
//    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        // Access the UITabBarController
//        if let tabBarController = self.tabBarController {
//            // Assuming the index of the TargetViewController in the tab bar's viewControllers array is 1 (change it according to your setup)
//            if let targetViewController = tabBarController.viewControllers?[2] as? OrderDetailsVC {
//                targetViewController.tableNumberText = tableNoLbl.text
//                targetViewController.coverTableText = coverTableLbl.text
//            }
//        }
//
//        if collectionView == itemcollectionView {
//            if let index = selectedIndexPaths.firstIndex(where: { $0 == indexPath }) {
//                // Item is already selected, deselect it
//                selectedIndexPaths.remove(at: index)
//                hideSubView() // Hide the subView when the item is deselected
//            } else {
//                // Item is not selected, proceed with selection logic
//                updateCountLabel()
//                showSubView()
//                itemCount = 0
//                updateItemCountLabel()
//
//
//                // Update selected items count and label
////                selectedItemsCount = selectedIndexPaths.count
////                itemSelectedLbl.text = "\(selectedItemsCount)"
//                selectedIndexPaths.append(indexPath)
//                selectedItemIndexPath = indexPath
//                if let cell = collectionView.cellForItem(at: indexPath) as? DineInCVCell {
//                    selectedItemName = cell.nameLabel?.text
//                    selectedItemPrice = cell.priceLabel?.text
//                    subViewLbl.text = selectedItemName
//                    subViewPriceLbl.text = selectedItemPrice
//                    // Check if there are any matching add-ons
//                    let matchingAddOns = apiResponseAddOns.filter { addOnItem in
//                        return addOnItem.itemName == selectedItemName
//                    }
//                    if matchingAddOns.isEmpty {
//                        // If there are no matching add-ons, hide the subView
//                        hideSubView()
//                        let newItem: [String: String] = [
//                            "itemName": selectedItemName ?? "",  // Add itemName to newItem
//                            "itemPrice": selectedItemPrice ?? "" ,
//                            "itemINCV": String(itemCountinCV)
//                        ]
//                        // Save the updated newItem to UserDefaults
//                        var savedItems = UserDefaults.standard.array(forKey: "addedItems") as? [[String: String]] ?? []
//                        savedItems.append(newItem)
//                        UserDefaults.standard.set(savedItems, forKey: "addedItems")
////                        showAlert(title: "Item Selected", message: "You selected: \(selectedItemName ?? "")")
//                        showToast(message: "You selected: \(selectedItemName ?? "")" , duration: 3.0)
//                    } else {
//                        showSubView()
//                    }
//                    if !matchingAddOns.isEmpty {
//                        let addOnNames = matchingAddOns.compactMap { $0.adsOnName }
//                        var selectedAddOnNames: [String] = []
//                        selectedAddOnNames.append(contentsOf: addOnNames)
//                    }
//                    addOnscollectionView.reloadData()
//                }
//            }
//            lastSelectedIndexPath = indexPath
//            collectionView.reloadItems(at: [indexPath])
//        } else if collectionView == addOnscollectionView {
//            if selectedAddOnIndexPaths.contains(indexPath) {
//                selectedAddOnIndexPaths.remove(indexPath)
//            } else {
//                selectedAddOnIndexPaths.insert(indexPath)
//            }
//            collectionView.reloadItems(at: [indexPath])
//        }
//    }
//}
////    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////        if collectionView == itemcollectionView {
////            updateCountLabel()
////            showSubView()
////            itemCount = 0
////            updateItemCountLabel()
////            // Update selected items count and label
////                    selectedItemsCount = selectedIndexPaths.count
////                    itemSelectedLbl.text = "\(selectedItemsCount)"
////            if selectedIndexPaths.contains(indexPath) {
////                selectedIndexPaths.removeAll { $0 == indexPath }
////            } else {
////                selectedIndexPaths.append(indexPath)
////                selectedItemIndexPath = indexPath
////                if let cell = collectionView.cellForItem(at: indexPath) as? DineInCVCell {
////                    selectedItemName = cell.nameLabel?.text
////                    selectedItemPrice = cell.priceLabel?.text
////                    subViewLbl.text = selectedItemName
////                    subViewPriceLbl.text = selectedItemPrice
////
////                    let matchingAddOns = apiResponseAddOns.filter { addOnItem in
////                        return addOnItem.itemName == selectedItemName
////                    }
////                    if !matchingAddOns.isEmpty {
////                        let addOnNames = matchingAddOns.compactMap { $0.adsOnName }
////                        var selectedAddOnNames: [String] = []
////                        selectedAddOnNames.append(contentsOf: addOnNames)
////                    }
////                    addOnscollectionView.reloadData()
////                }
////            }
////            lastSelectedIndexPath = indexPath
////            collectionView.reloadItems(at: [indexPath])
////        } else if collectionView == addOnscollectionView {
////            if collectionView == addOnscollectionView {
////                if selectedAddOnIndexPaths.contains(indexPath) {
////                    selectedAddOnIndexPaths.remove(indexPath)
////                } else {
////                    selectedAddOnIndexPaths.insert(indexPath)
////                }
////                collectionView.reloadItems(at: [indexPath])
////            }
////        }
////    }
////}
//
//




////    func apiCalling() {
////        APIManager.makePOSTRequest { dashboardModelArray in
////            self.apiResponse = dashboardModelArray.flatMap { $0 }
////            let rowItemData = dashboardModelArray[6]
////            let addOnsItemData = dashboardModelArray[7]
////            for dashboardModel in dashboardModelArray {
////                for row in dashboardModel {
////                    if let sectionID = row.categoryID, let sectionName = row.category {
////                        if !self.sectionNameToID.keys.contains(sectionName) {
////                            self.sectionNameToID[sectionName] = sectionID
////                            self.sectionNames.append(sectionName)
////                        }
////                        if let itemID = row.itemID {
////                            self.itemIDToSectionID[itemID] = sectionID
////                        }
////                    }
////
////                }
////            }
///
///
///
///
///
///
///
////            DispatchQueue.main.async {
////                self.apiResponse = rowItemData
////                self.apiResponseAddOns = addOnsItemData
////                self.segments.removeAllSegments()
////                self.sectionNameToID = self.sectionNameToID // Clear existing segments
////                for (index, sectionName) in self.sectionNames.enumerated() {
////                    self.segments.insertSegment(withTitle: sectionName, at: index, animated: false)
////                }
////                self.segments.selectedSegmentIndex = 0
////                self.itemcollectionView.reloadData()
////                self.addOnscollectionView.reloadData()
////            }
////        }
////    }
