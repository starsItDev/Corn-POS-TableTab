//////
//////  dineCV Helper code .swift
//////  Corn Tab
//////
//////  Created by StarsDev on 27/09/2023.
//////
////
//import Foundation
//@IBAction func segmentController(_ sender: UISegmentedControl) {
//    let selectedSegmentIndex = sender.selectedSegmentIndex
//    let segmentWidth = scrollView.contentSize.width / CGFloat(segments.numberOfSegments - 1)
//    var xOffset: CGFloat = 0
//    if selectedSegmentIndex < segments.numberOfSegments - 3 {
//        xOffset = max(0, segmentWidth * CGFloat(selectedSegmentIndex) - 400)
//    } else {
//        xOffset = scrollView.contentSize.width - scrollView.frame.width
//    }
//
//    // Clear previously selected cells
//    clearSelectedCells()
//
//    selectedIndexPaths.removeAll()
//    cellSelectionCounts.removeAll()
//    if let indexPaths = selectedIndexPathsForSegments[selectedSegmentIndex] {
//        selectedIndexPaths.append(contentsOf: indexPaths)
//        // Reload selected cells to update their appearance
//        itemcollectionView.reloadItems(at: indexPaths)
//    }
//    scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
//    itemCount = 0
//    updateItemCountLabel()
//    itemcollectionView.reloadData()
//    addOnscollectionView.reloadData()
//    hideSubView()
//    updateItemSelectedLabel()
//}
//
//// Helper method to clear previously selected cells
//func clearSelectedCells() {
//    for indexPath in selectedIndexPaths {
//        if let cell = itemcollectionView.cellForItem(at: indexPath) as? DineInCVCell {
//            cell.cellView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
//            // Clear qtyLbl
//            cell.qtyLbl.text = nil
//        }
//    }
//}


//
//  DealsVC.swift
//  Corn Tab
//
//  Created by StarsDev on 10/10/2023.
//

//import UIKit
//
//class DealsVC: UIViewController {
//
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
//
//
//
//
//    // MARK: Properties
//
//
//    var selectedIndexPathsForSegments: [Int: [IndexPath]] = [:]
//    var cellSelectionCountsForSegments: [Int: [IndexPath: Int]] = [:]
//    var cellSelectionCounts: [IndexPath: Int] = [:]
//    var selectedAddOnName: String?
//    var selectedItemIndexPath: IndexPath?
//    var selectedIndexPaths: [IndexPath] = []
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
//
//    var apiResponse: [MasterDetailRow] = []
//    var apiResponseAddOns: [MasterDetailRow] = []
//    var parsedRows: [[MasterDetailRow]] = []
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        navigationController?.setNavigationBarHidden(true, animated: false)
//        let boldFont = UIFont.boldSystemFont(ofSize: 20)
//        let attributes = [NSAttributedString.Key.font: boldFont]
//        segments.setTitleTextAttributes(attributes, for: .normal)
//        itemcollectionView.delegate = self
//        itemcollectionView.dataSource = self
//        itemcollectionView.reloadData()
//        hideSubView()
//        userDefaults()
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        if let labelText = receivedLabelText {
//            tableNoLbl.text = ": \(labelText)"
//        }
//        if let itemCount = receivedItemCount {
//            coverTableLbl.text = "\(itemCount)"
//        }
//        if let segment = receivedSegmentTitle, let text = receivedLabelText {
//            floorLbl.text = "\(segment)\nSelected Text: \(text)"
//        }
//        self.itemcollectionView.reloadData()
//    }
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        guard let flowLayout = itemcollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
//            return
//        }
//        let cellWidth = (UIScreen.main.bounds.width / 2) - 50
//        flowLayout.itemSize = CGSize(width: cellWidth, height: 100)
//        flowLayout.invalidateLayout()
//    }
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
//        for dashboardModel in self.parsedRows {
//            for row in dashboardModel {
//                if let sectionID = row.categoryID, let sectionName = row.dealName {
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
//           self.addOnscollectionView.reloadData()
//        }
//    }
//    @IBAction func closeButton(_ sender: UIButton) {
//        if let indexPath = selectedItemIndexPath {
//            if let cell = itemcollectionView.cellForItem(at: indexPath) as? DealsCVCell {
//                // Deselect the item and update the UI
//                if let index = selectedIndexPaths.firstIndex(where: { $0 == indexPath }) {
//                    selectedIndexPaths.remove(at: index)
//                    cell.cellView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
//                }
//            }
//        }
//        hideSubView()
//        clearSelectedAddOnIndexPaths()
//        addOnscollectionView.reloadData()
//        // Decrement the selectedItemCount by 1
//        if selectedIndexPaths.count > 0 {
//            selectedIndexPaths.removeLast()
//            updateItemSelectedLabel() // Update the label
//        }
//    }
//    @IBAction func addToOrder(_ sender: UIButton) {
//        guard itemCount > 0 else {
//            showAlert(title: "Error", message: "Please select items to add to the order.")
//            return
//        }
//        hideSubView()
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
//    @IBAction func segmentController(_ sender: UISegmentedControl) {
//        let selectedSegmentIndex = sender.selectedSegmentIndex
//        let segmentWidth = scrollView.contentSize.width / CGFloat(segments.numberOfSegments - 1)
//        var xOffset: CGFloat = 0
//        if selectedSegmentIndex < segments.numberOfSegments - 2 {
//            xOffset = max(0, segmentWidth * CGFloat(selectedSegmentIndex) - 300)
//        } else {
//            xOffset = scrollView.contentSize.width - scrollView.frame.width
//        }
//       clearSelectedCells()
//        selectedIndexPaths.removeAll()
//        cellSelectionCounts.removeAll()
//        if let indexPaths = selectedIndexPathsForSegments[selectedSegmentIndex] {
//            selectedIndexPaths.append(contentsOf: indexPaths)
//            itemcollectionView.reloadItems(at: indexPaths)
//        }
//        if let cellCounts = cellSelectionCountsForSegments[selectedSegmentIndex] {
//                cellSelectionCounts = cellCounts
//            }
//        scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
//        itemCount = 0
//        updateItemCountLabel()
//        itemcollectionView.reloadData()
//        addOnscollectionView.reloadData()
//        hideSubView()
//        updateItemSelectedLabel()
//    }
//    // MARK: Helper Methods
//    func clearSelectedCells() {
//        for indexPath in selectedIndexPaths {
//            if let cell = itemcollectionView.cellForItem(at: indexPath) as? DineInCVCell {
//                cell.cellView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
//                // Clear qtyLbl
//                cell.qtyLbl.text = nil
//            }
//        }
//    }
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
//    func updateItemSelectedLabel() {
//        let uniqueSelectedItems = Set(selectedIndexPaths)
//        let selectedItemCount = uniqueSelectedItems.count
//        itemSelectedLbl.text = "\(selectedItemCount)"
//    }
//}
//// MARK: Collection View
//extension DealsVC:  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == itemcollectionView{
//            guard segments.selectedSegmentIndex < sectionNames.count else {
//                return 0
//            }
//            let selectedSectionID = sectionNameToID[sectionNames[segments.selectedSegmentIndex]] ?? -1
//            let validItems = apiResponse.filter { item in
//                return item.categoryID == selectedSectionID && item.itemName != nil && item.price != 0 && item.imagePath != nil
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
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DealsCVCell", for: indexPath) as! DealsCVCell
//            let isSelected = selectedIndexPaths.contains(indexPath)
//            if isSelected {
//                cell.cellView.backgroundColor = #colorLiteral(red: 0.8596192002, green: 0.3426481783, blue: 0.2044148147, alpha: 1)
//            } else {
//                cell.cellView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
//            }
//            if let count = cellSelectionCounts[indexPath] {
//                cell.qtyLbl.text = "Qty: \(count)"
//            }
//            guard segments.selectedSegmentIndex < sectionNames.count else {
//                cell.nameLabel?.text = nil
//                cell.priceLabel?.text = nil
//                cell.imagePath?.image = nil
//                return cell
//            }
//            let selectedSectionID = sectionNameToID[sectionNames[segments.selectedSegmentIndex]] ?? -1
//            let validItems = apiResponse.filter { item in
//                return item.categoryID == selectedSectionID && item.itemName != nil && item.price != 0 && item.imagePath != nil
//            }
//            // Display item details in the cell
//            if indexPath.row < validItems.count {
//                let item = validItems[indexPath.row]
//                cell.nameLabel?.text = item.itemName
//                if let price = item.price {
//                    cell.priceLabel?.text = "\(price)"
//                }
//                cell.imagePath?.setImage(with: item.imagePath!)
//                // Check if there are any matching add-ons
//                let matchingAddOns = apiResponseAddOns.filter { addOnItem in
//                    return addOnItem.itemName == item.itemName
//                }
//                if matchingAddOns.isEmpty {
//                    cell.qtyLbl.isHidden = false
//                } else {
//                    cell.qtyLbl.isHidden = true
//                }
//                if let count = cellSelectionCounts[indexPath] {
//                    cell.qtyLbl.text = "Qty: \(count)"
//                }
//            }
//            return cell
//        }else{
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddOnDealCVCell", for: indexPath) as! AddOnDealCVCell
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
//    // MARK: UICollectionViewDelegate
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == itemcollectionView {
//            return CGSize(width: UIScreen.main.bounds.width/2 - 50, height: 100)
//        }
//        return CGSize(width: 175, height: 85)
//    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        updateItemSelectedLabel()
////        if let tabBarController = self.tabBarController {
////            if let targetViewController = tabBarController.viewControllers?[2] as? OrderDetailsVC {
////                targetViewController.tableNumberText = tableNoLbl.text
////                targetViewController.coverTableText = coverTableLbl.text
////            }
////        }
//        if collectionView == itemcollectionView {
//            let selectedSegmentIndex = segments.selectedSegmentIndex
//            if selectedIndexPathsForSegments[selectedSegmentIndex] == nil {
//                selectedIndexPathsForSegments[selectedSegmentIndex] = []
//            }
//            // Append the selected index path for the current segment.
//            selectedIndexPathsForSegments[selectedSegmentIndex]?.append(indexPath)
//            if cellSelectionCountsForSegments[selectedSegmentIndex] == nil {
//                cellSelectionCountsForSegments[selectedSegmentIndex] = [:]
//            }
//            if let count = cellSelectionCountsForSegments[selectedSegmentIndex]?[indexPath] {
//                cellSelectionCountsForSegments[selectedSegmentIndex]?[indexPath] = count + 1
//            } else {
//                cellSelectionCountsForSegments[selectedSegmentIndex]?[indexPath] = 1
//            }
//            hideSubView()
//            showSubView()
//            itemCount = 0
//            updateItemCountLabel()
//            selectedIndexPaths.append(indexPath)
//            selectedItemIndexPath = indexPath
//
//            if let cell = collectionView.cellForItem(at: indexPath) as? DealsCVCell {
//                selectedItemName = cell.nameLabel?.text
//                selectedItemPrice = cell.priceLabel?.text
//                subViewLbl.text = selectedItemName
//                subViewPriceLbl.text = selectedItemPrice
//                // Check if there are any matching add-ons
//                let matchingAddOns = apiResponseAddOns.filter { addOnItem in
//                    return addOnItem.itemName == selectedItemName
//                }
//                if matchingAddOns.isEmpty {
//                    hideSubView()
//                    let newItem: [String: String] = [
//                        "itemName": selectedItemName ?? "",
//                        "itemPrice": selectedItemPrice ?? "" ,
//                        "itemINCV": String(itemCountinCV)
//                    ]
//                    var savedItems = UserDefaults.standard.array(forKey: "addedItems") as? [[String: String]] ?? []
//                    if let existingItemIndex = savedItems.firstIndex(where: { $0["itemName"] == selectedItemName }) {
//                        if let existingItemINCV = Int(savedItems[existingItemIndex]["itemINCV"] ?? "0") {
//                            savedItems[existingItemIndex]["itemINCV"] = String(existingItemINCV + 1)
//                        }
//                    } else {
//                        savedItems.append(newItem)
//                    }
//                    UserDefaults.standard.set(savedItems, forKey: "addedItems")
//                    showToast(message: "You selected: \(selectedItemName ?? "")" , duration: 3.0)
//                } else {
//                    showSubView()
//                }
//                if !matchingAddOns.isEmpty {
//                    let addOnNames = matchingAddOns.compactMap { $0.adsOnName }
//                    var selectedAddOnNames: [String] = []
//                    selectedAddOnNames.append(contentsOf: addOnNames)
//                }
//                addOnscollectionView.reloadData()
//            }
//            selectedItemIndexPath = indexPath
//            collectionView.reloadItems(at: [indexPath])
//            if let count = cellSelectionCounts[indexPath] {
//                cellSelectionCounts[indexPath] = count + 1
//            }
//            else {
//                cellSelectionCounts[indexPath] = 1
//            }
//            if let cell = collectionView.cellForItem(at: indexPath) as? DealsCVCell {
//                if let count = cellSelectionCounts[indexPath] {
//                    cell.qtyLbl.text = "Qty: \(count)"
//                }
//            }
//            updateItemSelectedLabel()
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
