////
////  DealsVC.swift
////  Corn Tab
////  Created by StarsDev on 10/10/2023.
//
//import UIKit
//class DealsVC: UIViewController {
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
//    @IBOutlet weak var segmentsFirstDeals: UISegmentedControl!
//    // MARK: Properties
//    var dealId: Int = 0
//    var selectedIndexPathsForSegments: [Int: [IndexPath]] = [:]
//    var cellSelectionCountsForSegments: [Int: [IndexPath: Int]] = [:]
//    var cellSelectionCounts: [IndexPath: Int] = [:]
//    var selectedAddOnName: String?
//    var selectedItemIndexPath: IndexPath?
//    var selectedIndexPaths: [IndexPath] = []
//
//    var sectionNames: [String] = []
//    var sectionNameToPrice: [String: Int] = [:]
//    var sectionNamesQTY: [String] = []
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
//    var itemCount = 1
//    var categoryNamesForDeal: [String] = []
//    var apiResponse: [MasterDetailRow] = []
//    var apiResponseAddOns: [MasterDetailRow] = []
//    var parsedRows: [[MasterDetailRow]] = []
//
//    var selectedAddOns: [String] = []
//    var selectedAddOnPrices: [Double] = []
//    var isDeal = false
//
//    // MARK: View Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        navigationController?.setNavigationBarHidden(true, animated: false)
//        let boldFont = UIFont.boldSystemFont(ofSize: 20)
//        let attributes = [NSAttributedString.Key.font: boldFont]
//        segments.setTitleTextAttributes(attributes, for: .normal)
//        segmentsFirstDeals.setTitleTextAttributes(attributes, for: .normal)
//        segmentsFirstDeals.selectedSegmentIndex = 0
//        itemcollectionView.delegate = self
//        itemcollectionView.dataSource = self
//        itemcollectionView.reloadData()
//        hideSubView()
//        userDefaults()
//    }
//    // MARK: Override Func
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
//    // MARK: Actions
//    @IBAction func segmentsFirstDeals(_ sender: UISegmentedControl) {
//        let selectedSegmentIndex = sender.selectedSegmentIndex
//        if selectedSegmentIndex >= 0 {
//            sectionNamesQTY.removeAll()
//            sectionNames.removeAll()
//            let segmentTitle = sender.titleForSegment(at: selectedSegmentIndex) ?? ""
//            if let newDealId = sectionNameToID[segmentTitle] {
//                dealId = newDealId
//            }
//            let segmentWidth = scrollView.contentSize.width / CGFloat(segmentsFirstDeals.numberOfSegments - 1)
//            var xOffset: CGFloat = 0
//            if selectedSegmentIndex < segmentsFirstDeals.numberOfSegments - 3 {
//                xOffset = max(0, segmentWidth * CGFloat(selectedSegmentIndex) - 400)
//            } else {
//                xOffset = scrollView.contentSize.width - scrollView.frame.width
//            }
//            scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
//            sectionNames.removeAll()
//            categoryNamesForDeal.removeAll()
//            segments.removeAllSegments()
//            sectionNameToID.removeAll()
//            var sectionNameToID: [String: Int] = [:]
//            for dashboardModel in self.parsedRows {
//                for row in dashboardModel {
//                    if let rowDealID = row.dealID,let _ = row.categoryID, rowDealID == dealId {
//                        if let categoryName = row.categoryName {
//                            categoryNamesForDeal.append(categoryName)
//                        }
//                    }
//                }
//            }
//            for dashboardModel in self.parsedRows {
//                for row in dashboardModel {
//                    if let rowDealID = row.dealID, let rowcategoryID = row.categoryID, let DealItemQuantity = row.dealItemQuantity, rowDealID == self.dealId {
//                        // Found a match, add the categoryName to the array
//                        if let sectionName = row.categoryName {
//                            if !sectionNameToID.keys.contains(sectionName) {
//                                sectionNameToID[sectionName] = rowcategoryID
//                                self.sectionNamesQTY.append("\(sectionName) (\(DealItemQuantity))")
//                                self.sectionNames.append(sectionName)
//                            }
//                        }
//                    }
//                }
//            }
//            for dashboardModel in self.parsedRows {
//                for row in dashboardModel {
//                    if let sectionID = row.dealID, let sectionName = row.dealName {
//                        if !sectionNameToID.keys.contains(sectionName) {
//                            sectionNameToID[sectionName] = sectionID
//                        }
//                        if let itemID = row.categoryID {
//                            self.itemIDToSectionID[itemID] = sectionID
//                        }
//                    }
//                }
//            }
//            // UI updates can be performed here
//            //DispatchQueue.main.async {
//            self.segments.removeAllSegments()
//            self.sectionNameToID = sectionNameToID
//            for (index, sectionName) in self.sectionNamesQTY.enumerated() {
//                self.segments.insertSegment(withTitle: sectionName, at: index, animated: false)
//            }
//            self.segments.selectedSegmentIndex = 0
//
//            // }
//            self.itemcollectionView.reloadData()
//            self.addOnscollectionView.reloadData()
//            clearSelectedCells()
//            selectedIndexPaths.removeAll()
//            cellSelectionCounts.removeAll()
//            if let indexPaths = selectedIndexPathsForSegments[selectedSegmentIndex] {
//                selectedIndexPaths.append(contentsOf: indexPaths)
//                itemcollectionView.reloadItems(at: indexPaths)
//            }
//            if let cellCounts = cellSelectionCountsForSegments[selectedSegmentIndex] {
//                // If there were previously selected cells for this segment, store them in cellSelectionCounts.
//                cellSelectionCounts = cellCounts
//            }
//            itemCount = 1
//            updateItemCountLabel()
//            itemcollectionView.reloadData()
//            addOnscollectionView.reloadData()
//            hideSubView()
//            updateItemSelectedLabel()
//        }
//    }
//    @IBAction func segmentController(_ sender: UISegmentedControl) {
//        let selectedSegmentIndex = sender.selectedSegmentIndex
//        clearSelectedCells()
//        selectedIndexPaths.removeAll()
//        cellSelectionCounts.removeAll()
//
//        if let indexPaths = selectedIndexPathsForSegments[selectedSegmentIndex] {
//            selectedIndexPaths.append(contentsOf: indexPaths)
//            itemcollectionView.reloadItems(at: indexPaths)
//        }
//        if let cellCounts = cellSelectionCountsForSegments[selectedSegmentIndex] {
//            // If there were previously selected cells for this segment, store them in cellSelectionCounts.
//            cellSelectionCounts = cellCounts
//        }
//        itemCount = 0
//        updateItemCountLabel()
//        itemcollectionView.reloadData()
//        addOnscollectionView.reloadData()
//        hideSubView()
//        updateItemSelectedLabel()
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
//        //var selectedAddOns: [String] = []
//        //            var selectedAddOnPrices: [Double] = []
//
//        for indexPath in selectedAddOnIndexPaths {
//            if let cell = addOnscollectionView.cellForItem(at: indexPath) as? AddOnDealCVCell,
//               let addOnName = cell.nameLabel.text,
//               let addOnPriceText = cell.priceLabel.text,
//               //                   let itemId = cell.item
//               let addOnPrice = Double(addOnPriceText.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
//                let addOnInfo = "\(addOnName) (\(addOnPrice))"
//                selectedAddOns.append(addOnInfo)
//                selectedAddOnPrices.append(addOnPrice)
//            }
//        }
//        let segmentName = segmentsFirstDeals.titleForSegment(at: segmentsFirstDeals.selectedSegmentIndex) ?? ""
//        let totalAddOnPrice = selectedAddOnPrices.reduce(0, +)
//        let totalPrice = Double(sectionNameToPrice[segmentName] ?? 0) + totalAddOnPrice
//
//        let titleWithPrice: String
//        //        if selectedAddOnsString.isEmpty {
//        //            titleWithPrice = title
//        //        } else {
//        titleWithPrice = "\(segmentName) - (\(sectionNameToPrice[segmentName] ?? 0))"
//        //}
//        var savedItems = UserDefaults.standard.array(forKey: "addedItems") as? [[String: String]] ?? []
//        if let existingSegment = savedItems.firstIndex(where: {$0["DealName"] == titleWithPrice}){
//            selectedAddOns.append(selectedItemName ?? "")
//        }
//        else{
//            selectedAddOns.removeAll()
//            selectedAddOnPrices.removeAll()
//            selectedAddOns.append(selectedItemName ?? "")
//        }
//        let selectedAddOnsString = selectedAddOns.joined(separator: "\n")
//
//        let newItem: [String: String] = [
//            "isDeals": "true",
//            "DealName": titleWithPrice,
//            //"DealID": ,
//            "BasePrice": "\(sectionNameToPrice[segmentName] ?? 0)",
//            "Title": selectedItemName ?? "",
//            "Qty": quantity,
//            "Price": "\(totalPrice)",
//            "SelectedAddOns": selectedAddOnsString,
//            "isAddOn": "true"
//        ]
//        if let existingSegment = savedItems.firstIndex(where: {$0["DealName"] == titleWithPrice}){
//            savedItems[existingSegment]["SelectedAddOns"] = "\(selectedAddOnsString)"
//            savedItems[existingSegment]["Price"] = "\(totalPrice)"
//        }
//        else {
//            savedItems.append(newItem)
//        }
//        //savedItems.append(newItem)
//        UserDefaults.standard.set(savedItems, forKey: "addedItems")
//        clearSelectedAddOnIndexPaths()
//        addOnscollectionView.reloadData()
//    }
//    @IBAction func minusButton(_ sender: UIButton) {
//        itemCount = max(1, itemCount - 1)
//        updateItemCountLabel()
//    }
//    @IBAction func plusButton(_ sender: UIButton) {
//        itemCount += 1
//        updateItemCountLabel()
//    }
//    // MARK: Helper Methods
//    func userDefaults() {
//        if let savedData = UserDefaults.standard.data(forKey: "parsedDataKey"),
//           let rows = try? JSONDecoder().decode([[MasterDetailRow]].self, from: savedData) {
//            self.parsedRows = rows
//        } else {
//            // Handle the case where no data is saved in UserDefaults
//        }
//        // Move your API response processing logic here
//        var sectionNameToID: [String: Int] = [:]
//
//        // Check if parsedRows has enough elements
//        guard self.parsedRows.count > 6 else {
//            // Handle the case where parsedRows doesn't have enough elements
//            return
//        }
//
//        let rowItemData = self.parsedRows[6]
//        let addOnsItemData = self.parsedRows[7]
//
//        for dashboardModel in self.parsedRows {
//            for row in dashboardModel {
//                if let rowDealID = row.dealID, let rowcategoryID = row.categoryID, rowDealID == self.dealId {
//                    // Found a match, add the categoryName to the array
//                    //                        print(dealId)
//                    if let sectionName = row.categoryName {
//                        if !sectionNameToID.keys.contains(sectionName) {
//                            sectionNameToID[sectionName] = rowcategoryID
//                            self.sectionNames.append(sectionName)
//                        }
//                    }
//                }
//            }
//        }
//        segmentsFirstDeals.removeAllSegments()
//        for dashboardModel in self.parsedRows {
//            for row in dashboardModel {
//                if let sectionID = row.dealID, let sectionName = row.dealName {
//                    if !sectionNameToID.keys.contains(sectionName) {
//                        sectionNameToID[sectionName] = sectionID
//                        // Add segment to segmented control
//                        segmentsFirstDeals.insertSegment(withTitle: sectionName, at: segmentsFirstDeals.numberOfSegments, animated: false)
//                        sectionNameToPrice[sectionName] = row.dealPrice
//                    }
//                    if let itemID = row.categoryID {
//                        self.itemIDToSectionID[itemID] = sectionID
//                    }
//                }
//            }
//        }
//        //        segmentsFirstDeals.selectedSegmentIndex = 0
//        // UI updates can be performed here
//        //DispatchQueue.main.async {
//        self.apiResponse = rowItemData
//        self.apiResponseAddOns = addOnsItemData
//        self.segments.removeAllSegments()
//        self.sectionNameToID = sectionNameToID // Clear existing segments
//        for (index, sectionName) in self.sectionNames.enumerated() {
//            self.segments.insertSegment(withTitle: sectionName, at: index, animated: false)
//        }
//        self.segments.selectedSegmentIndex = 0
//        self.itemcollectionView.reloadData()
//        self.addOnscollectionView.reloadData()
//
//        //}
//    }
//    func clearSelectedCells() {
//        for indexPath in selectedIndexPaths {
//            if let cell = itemcollectionView.cellForItem(at: indexPath) as? DealsCVCell {
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
//        if collectionView == itemcollectionView {
//            guard segments.selectedSegmentIndex >= 0, segments.selectedSegmentIndex < sectionNames.count else {
//                return 0
//            }
//
//            let selectedSectionID = sectionNameToID[sectionNames[segments.selectedSegmentIndex]] ?? -1
//            let validItems = apiResponse.filter { item in
//                return item.categoryID == selectedSectionID && item.itemName != nil
//            }
//            return validItems.count
//        } else if collectionView == addOnscollectionView {
//            // Check if selectedItemName is set
//            guard let selectedItemName = selectedItemName else {
//                return 0
//            }
//
//            // Filter matching add-ons based on selectedItemName
//            let matchingAddOns = apiResponseAddOns.filter { $0.itemName == selectedItemName && $0.adsOnName != nil }
//            return matchingAddOns.count
//        }
//
//        return 0
//    }
//
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
//
//            guard segments.selectedSegmentIndex < sectionNames.count else {
//                cell.nameLabel?.text = nil
//                //                cell.priceLabel?.text = nil
//                cell.imagePath?.image = nil
//
//                return cell
//            }
//            let selectedSectionID = sectionNameToID[sectionNames[segments.selectedSegmentIndex]] ?? -1
//            let validItems = apiResponse.filter { item in
//                return item.categoryID == selectedSectionID && item.itemName != nil
//                //                && item.price != 0
//                //               && item.imagePath != ""
//            }
//            // Display item details in the cell
//            if indexPath.row < validItems.count {
//                let item = validItems[indexPath.row]
//                cell.nameLabel?.text = item.itemName
//                if let price = item.price {
//                    cell.priceLabel?.text = "\(price)"
//                }
//                if let imagePath = item.imagePath, !imagePath.isEmpty {
//                    // If item.imagePath is not nil and not empty, set the image with the provided path
//                    cell.imagePath?.setImage(with: imagePath)
//                } else {
//                    // If item.imagePath is nil or empty, set a default or "Demi" image
//                    cell.imagePath?.image = #imageLiteral(resourceName: "icons8-food-64")
//                }
//
//                //                cell.imagePath?.setImage(with: item.imagePath ?? "")
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
//                    cell.itemId = matchingAddOns[indexPath.item].itemID
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
//
//
//
//    //collectionview didSelect in DealsVC
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        updateItemSelectedLabel()
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
//            itemCount = 1
//            updateItemCountLabel()
//            selectedIndexPaths.append(indexPath)
//            selectedItemIndexPath = indexPath
//
//            if let cell = collectionView.cellForItem(at: indexPath) as? DealsCVCell {
//                selectedItemName = cell.nameLabel?.text
//                selectedItemPrice = cell.priceLabel?.text
//                subViewLbl.text = selectedItemName
//                subViewPriceLbl.text = selectedItemPrice
//                //let dealId = cell.dealId
//                // Check if there are any matching add-ons
//                let matchingAddOns = apiResponseAddOns.filter { addOnItem in
//                    return addOnItem.itemName == selectedItemName
//                }
//
//                if matchingAddOns.isEmpty {
//                    hideSubView()
//                    //                    let newItem: [String: String] = [
//                    //                        "itemName": selectedItemName ?? "",
//                    //                        "itemPrice": selectedItemPrice ?? "" ,
//                    //                        "itemINCV": String(itemCountinCV)
//                    //                    ]
//
//                    let segmentName = segmentsFirstDeals.titleForSegment(at: segmentsFirstDeals.selectedSegmentIndex) ?? ""
//                    let titleWithPrice = "\(segmentName) - (\(sectionNameToPrice[segmentName] ?? 0))"
//                    let totalAddOnPrice = selectedAddOnPrices.reduce(0, +)
//                    let totalPrice = Double(sectionNameToPrice[segmentName] ?? 0) + totalAddOnPrice
//                    var savedItems = UserDefaults.standard.array(forKey: "addedItems") as? [[String: String]] ?? []
//                    if let existingSegment = savedItems.firstIndex(where: {$0["DealName"] == titleWithPrice}){
//                        selectedAddOns.append(selectedItemName ?? "")
//                    }
//                    else{
//                        selectedAddOns.removeAll()
//                        selectedAddOnPrices.removeAll()
//                        selectedAddOns.append(selectedItemName ?? "")
//                    }
//                    let selectedAddOnsString = selectedAddOns.joined(separator: "\n")
//
//                    let newItem: [String: String] = [
//                        "isDeals": "true",
//                        "DealName": titleWithPrice ,
//                        "Title": selectedItemName ?? "",
//                        "BasePrice": "\(sectionNameToPrice[segmentName] ?? 0)" ,
//                        "Price" : "\(totalPrice)",
//                        "Qty": String(itemCountinCV),
//                        "DealID": String(dealId ?? 0),
//                        "SelectedAddOns": selectedAddOnsString
//                    ]
//                    //var savedItems = UserDefaults.standard.array(forKey: "addedItems") as? [[String: String]] ?? []
//                    if let existingItemIndex = savedItems.firstIndex(where: { $0["itemName"] == selectedItemName }) {
//                        if let existingItemINCV = Int(savedItems[existingItemIndex]["itemINCV"] ?? "0") {
//                            savedItems[existingItemIndex]["itemINCV"] = String(existingItemINCV + 1)
//                        }
//                    }
//                    if let existingSegment = savedItems.firstIndex(where: {$0["DealName"] == titleWithPrice}){
//                        savedItems[existingSegment]["SelectedAddOns"] = "\(selectedAddOnsString)"
//                        savedItems[existingSegment]["Price"] = "\(totalPrice)"
//                    }
//                    else {
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
