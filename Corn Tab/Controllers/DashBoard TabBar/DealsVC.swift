//
//  DealsVC.swift
//  Corn Tab
//  Created by StarsDev on 10/10/2023.

import UIKit

class DealsVC: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var segments: UISegmentedControl!
    @IBOutlet weak var itemViewLbl: UILabel!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var itemSelectedLbl: UILabel!
    @IBOutlet weak var subViewLbl: UILabel!
    @IBOutlet weak var subViewPriceLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var quntityLbl: UILabel!
    @IBOutlet weak var itemcollectionView: UICollectionView!
    @IBOutlet weak var addOnscollectionView: UICollectionView!
    @IBOutlet weak var segmentsFirstDeals: UISegmentedControl!
    
    // MARK: Properties
    var intValueSelectionCounts: [Int: Int] = [:]
    var dealId: Int = 0
    var selectedIndexPathsForSegments: [Int: [IndexPath]] = [:]
    var cellSelectionCountsForSegments: [Int: [IndexPath: Int]] = [:]
    var cellSelectionCounts: [IndexPath: Int] = [:]
    var selectedAddOnName: String?
    var selectedItemIndexPath: IndexPath?
    var selectedIndexPaths: [IndexPath] = []
    var dealItem: [String: String] = [:]
    
    var sectionNames: [String] = []
    var sectionNameToPrice: [String: Int] = [:]
    var sectionNamesQTY: [String] = []
    var itemIDToSectionID: [Int: Int] = [:]
    var sectionNameToID: [String: Int] = [:]
    var selectedAddOnIndexPaths: Set<IndexPath> = []
    var selectedAddOnToItemId: [String] = []
    var receivedLabelText: String?
    var receivedSegmentTitle: String?
    var receivedItemCount: String? = nil
    
    var selectedItemName: String?
    var selectedItemPrice: String?
    var selectedItemId: Int?
    var itemCountinCV = 1
    var itemCount = 1
    var categoryNamesForDeal: [String] = []
    var apiResponse: [MasterDetailRow] = []
    var apiResponseAddOns: [MasterDetailRow] = []
    var parsedRows: [[MasterDetailRow]] = []
    
    var itemNameArr: [String] = []
    var itemIdArr: [String] = []
    var selectedAddOns: [String] = []
    var selectedAddOnsForAPI: [String] = []
    var selectedAddOnsId: [String] = []
    var dealItemName: [Int:String] = [:]
    var dealAddOnName: [Int: String] = [:]
    var selectedAddOnPrices: [Double] = []
    var isDeal = false
    var previousSelectedIndex: Int = 0
    

    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        let boldFont = UIFont.boldSystemFont(ofSize: 20)
        let attributes = [NSAttributedString.Key.font: boldFont]
        segments.setTitleTextAttributes(attributes, for: .normal)
        segmentsFirstDeals.setTitleTextAttributes(attributes, for: .normal)
        segmentsFirstDeals.selectedSegmentIndex = 0
        itemcollectionView.delegate = self
        itemcollectionView.dataSource = self
        //itemcollectionView.allowsMultipleSelection = false
        itemcollectionView.reloadData()
        hideSubView()
        userDefaults()
        for segmentIndex in 0..<segments.numberOfSegments {
            selectedIndexPathsForSegments[segmentIndex] = []
        }
    }
    // MARK: Override Func
    override func viewWillAppear(_ animated: Bool) {
        let selectedIndices = UserDefaults.standard.integer(forKey: "selectedIndexPaths")
        if selectedIndices == 0{
            selectedIndexPaths.removeAll()
            intValueSelectionCounts.removeAll()
        }
        let selectedIndicesForSegment = UserDefaults.standard.integer(forKey: "selectedIndexPathsForSegments")
        if selectedIndicesForSegment == 0{
            selectedIndexPathsForSegments.removeAll()
        }
        self.itemcollectionView.reloadData()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let flowLayout = itemcollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        let cellWidth = (UIScreen.main.bounds.width / 2) - 50
        flowLayout.itemSize = CGSize(width: cellWidth, height: 100)
        flowLayout.invalidateLayout()
    }
    // MARK: Actions
    @IBAction func segmentsFirstDeals(_ sender: UISegmentedControl) {
        var intValue = 0
        var totalCount = 0
        if sectionNamesQTY.isEmpty{
            let segmentTitle = sender.titleForSegment(at: sender.selectedSegmentIndex) ?? ""
            if let newDealId = sectionNameToID[segmentTitle] {
                dealId = newDealId
            }
            for dashboardModel in self.parsedRows {
                for row in dashboardModel {
                    if let rowDealID = row.dealID, let rowcategoryID = row.categoryID, let DealItemQuantity = row.dealItemQuantity, rowDealID == self.dealId {
                        // Found a match, add the categoryName to the array
                        if let sectionName = row.categoryName {
                            if !sectionNameToID.keys.contains(sectionName) {
                                sectionNameToID[sectionName] = rowcategoryID
                                self.sectionNamesQTY.append("\(sectionName) (\(DealItemQuantity))")
                                self.sectionNames.append(sectionName)
                            }
                        }
                    }
                }
            }
            
        }
        for (_, sectionName) in self.sectionNamesQTY.enumerated() {
            if let extractedIntValue = sectionName.extractIntFromParentheses(){
                intValue = intValue + extractedIntValue
            }
        }
        //UserDefaults.standard.set(intValue, forKey: "DealCount")
        for (_, indexPaths) in selectedIndexPathsForSegments {
                totalCount += indexPaths.count
            }
        if totalCount < intValue && totalCount > 0{
            let alert = UIAlertController(title: "Alert", message: "Deal is incomplete", preferredStyle: .alert)
            let continueAction = UIAlertAction(title: "Continue", style: .cancel) { _ in
                sender.selectedSegmentIndex = self.previousSelectedIndex
            }
            let removeAction = UIAlertAction(title: "Remove Deal", style: .default) { _ in
                //                        tabBarController.selectedIndex = 3
                UserDefaults.standard.removeObject(forKey: "newDealItem")
                if let indexPath = self.selectedItemIndexPath {
                    let selectedSegment = self.segments.selectedSegmentIndex
                    if let cell = self.itemcollectionView.cellForItem(at: indexPath) as? DealsCVCell {
                        // Deselect the item and update the UI
                        if let index = self.selectedIndexPaths.firstIndex(where: { $0 == indexPath }) {
                            self.selectedIndexPaths.remove(at: index)
                            self.selectedIndexPathsForSegments[selectedSegment]?.remove(at: index)
                            cell.cellView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                        }
                    }
                }
                self.selectedIndexPaths.removeAll()
                self.selectedIndexPathsForSegments.removeAll()
                sender.selectedSegmentIndex = self.previousSelectedIndex
            }
            
            alert.addAction(continueAction)
            alert.addAction(removeAction)
            tabBarController?.present(alert, animated: false, completion: nil)
        }
        else{
        let selectedSegmentIndex = sender.selectedSegmentIndex
            previousSelectedIndex = selectedSegmentIndex
        intValueSelectionCounts = [:]
        if selectedSegmentIndex >= 0 {
            sectionNamesQTY.removeAll()
            sectionNames.removeAll()
            
            let segmentTitle = sender.titleForSegment(at: selectedSegmentIndex) ?? ""
            if let newDealId = sectionNameToID[segmentTitle] {
                dealId = newDealId
            }
            let segmentWidth = scrollView.contentSize.width / CGFloat(segmentsFirstDeals.numberOfSegments - 1)
            var xOffset: CGFloat = 0
            if selectedSegmentIndex < segmentsFirstDeals.numberOfSegments - 3 {
                xOffset = max(0, segmentWidth * CGFloat(selectedSegmentIndex) - 400)
            } else {
                xOffset = scrollView.contentSize.width - scrollView.frame.width
            }
            scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
            sectionNames.removeAll()
            categoryNamesForDeal.removeAll()
            segments.removeAllSegments()
            sectionNameToID.removeAll()
            var sectionNameToID: [String: Int] = [:]
            for dashboardModel in self.parsedRows {
                for row in dashboardModel {
                    if let rowDealID = row.dealID,let _ = row.categoryID, rowDealID == dealId {
                        if let categoryName = row.categoryName {
                            categoryNamesForDeal.append(categoryName)
                        }
                    }
                }
            }
            for dashboardModel in self.parsedRows {
                for row in dashboardModel {
                    if let rowDealID = row.dealID, let rowcategoryID = row.categoryID, let DealItemQuantity = row.dealItemQuantity, rowDealID == self.dealId {
                        // Found a match, add the categoryName to the array
                        if let sectionName = row.categoryName {
                            if !sectionNameToID.keys.contains(sectionName) {
                                sectionNameToID[sectionName] = rowcategoryID
                                self.sectionNamesQTY.append("\(sectionName) (\(DealItemQuantity))")
                                self.sectionNames.append(sectionName)
                            }
                        }
                    }
                }
            }
            for dashboardModel in self.parsedRows {
                for row in dashboardModel {
                    if let sectionID = row.dealID, let sectionName = row.dealName {
                        if !sectionNameToID.keys.contains(sectionName) {
                            sectionNameToID[sectionName] = sectionID
                        }
                        if let itemID = row.categoryID {
                            self.itemIDToSectionID[itemID] = sectionID
                        }
                    }
                }
            }
            
            self.segments.removeAllSegments()
            self.sectionNameToID = sectionNameToID
            for (index, sectionName) in self.sectionNamesQTY.enumerated() {
                self.segments.insertSegment(withTitle: sectionName, at: index, animated: false)
                
            }
            
            //            var intValue: Int?
            //            //itemcollectionView.allowsMultipleSelection = false
            //            for (index, sectionName) in self.sectionNamesQTY.enumerated() {
            //                if let extractedIntValue = sectionName.extractIntFromParentheses(), index == selectedSegmentIndex {
            //                    intValue = extractedIntValue
            //                    print("Selected intValue: \(intValue ?? 0)")
            //                    let itemcellCount = (intValueSelectionCounts[intValue ?? 0] ?? 0) + 1
            //                    intValueSelectionCounts[intValue ?? 0] = itemcellCount
            //                    print("Count for \(intValue ?? 0): \(itemcellCount)")
            //                }
            //            }
            self.segments.selectedSegmentIndex = 0
            self.itemcollectionView.reloadData()
            self.addOnscollectionView.reloadData()
            clearSelectedCells()
            selectedIndexPathsForSegments.removeAll()
            selectedIndexPaths.removeAll()
            cellSelectionCounts.removeAll()
            
            
            // Assuming selectedSegmentIndex is an integer
            if let indexPaths = selectedIndexPathsForSegments[selectedSegmentIndex] {
                selectedIndexPaths.append(contentsOf: indexPaths)
                                itemcollectionView.reloadItems(at: indexPaths)
            } else {
                // Handle the case where selectedSegmentIndex is out of bounds or the array is nil
                print("Invalid selectedSegmentIndex or nil array")
            }
            if let cellCounts = cellSelectionCountsForSegments[selectedSegmentIndex] {
                cellSelectionCounts = cellCounts
            }
            itemCount = 1
            updateItemCountLabel()
            itemcollectionView.reloadData()
            addOnscollectionView.reloadData()
            hideSubView()
            updateItemSelectedLabel()
        }
    }
    }
    @IBAction func segmentController(_ sender: UISegmentedControl) {
        let selectedSegmentIndex = sender.selectedSegmentIndex
        if selectedSegmentIndex >= 0 {
            if let selectedSegmentText = sender.titleForSegment(at: selectedSegmentIndex) {
                if let intValueINdex1 = selectedSegmentText.extractIntFromParentheses() {
                    print("Selected Segment Integer Value: \(intValueINdex1)")
                }
            }
        }
        clearSelectedCells()
        selectedIndexPaths.removeAll()
        cellSelectionCounts.removeAll()
        
        if let indexPaths = selectedIndexPathsForSegments[selectedSegmentIndex] {
            selectedIndexPaths.append(contentsOf: indexPaths)
            //            itemcollectionView.reloadItems(at: indexPaths)
        }
        if let cellCounts = cellSelectionCountsForSegments[selectedSegmentIndex] {
            cellSelectionCounts = cellCounts
        }
        itemCount = 0
        updateItemCountLabel()
        itemcollectionView.reloadData()
        addOnscollectionView.reloadData()
        hideSubView()
        updateItemSelectedLabel()
    }
    @IBAction func closeButton(_ sender: UIButton) {
        if let indexPath = selectedItemIndexPath {
            intValueSelectionCounts = [:]
            let selectedSegment = segments.selectedSegmentIndex
            if let cell = itemcollectionView.cellForItem(at: indexPath) as? DealsCVCell {
                // Deselect the item and update the UI
                if let index = selectedIndexPaths.firstIndex(where: { $0 == indexPath }) {
                    selectedIndexPaths.remove(at: index)
                    selectedIndexPathsForSegments[selectedSegment]?.remove(at: index)
                    cell.cellView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                }
            }
        }
        hideSubView()
        clearSelectedAddOnIndexPaths()
        addOnscollectionView.reloadData()
        if selectedIndexPaths.count > 0 {
            //selectedIndexPaths.removeLast()
            updateItemSelectedLabel() // Update the label
        }
    }
    @IBAction func addToOrder(_ sender: UIButton) {
        guard itemCount > 0 else {
            showAlert(title: "Error", message: "Please select items to add to the order.")
            return
        }
        //        selectedAddOns.removeAll()
        //        selectedAddOnsForAPI.removeAll()
        //        selectedAddOnsId.removeAll()
        let segmentName = segmentsFirstDeals.titleForSegment(at: segmentsFirstDeals.selectedSegmentIndex) ?? ""
        let titleWithPrice: String
        titleWithPrice = "\(segmentName) - (\(sectionNameToPrice[segmentName] ?? 0))"
        var savedItems = UserDefaults.standard.array(forKey: "newDealItem") as? [[String: String]] ?? []
        if savedItems.firstIndex(where: {$0["DealName"] == titleWithPrice}) != nil{
            selectedAddOns.append(selectedItemName ?? "")
            itemIdArr.append("\(selectedItemId ?? 0)")
            itemNameArr.append(selectedItemName ?? "")
        }
        else{
            selectedAddOnToItemId.removeAll()
            selectedAddOnsId.removeAll()
            selectedAddOnsForAPI.removeAll()
            selectedAddOns.removeAll()
            selectedAddOnPrices.removeAll()
            itemIdArr.removeAll()
            itemNameArr.removeAll()
            selectedAddOns.append(selectedItemName ?? "")
            itemIdArr.append("\(selectedItemId ?? 0)")
            itemNameArr.append(selectedItemName ?? "")
        }
        hideSubView()
        let title = titleLbl.text ?? ""
        let quantity = quntityLbl.text ?? ""
        let basePriceText = subViewPriceLbl.text ?? "0.0"
        let basePrice = Double(basePriceText) ?? 0.0
        //var selectedAddOns: [String] = []
        //            var selectedAddOnPrices: [Double] = []
        for indexPath in selectedAddOnIndexPaths {
            if let cell = addOnscollectionView.cellForItem(at: indexPath) as? AddOnDealCVCell,
               let addOnName = cell.nameLabel.text,
               let addOnPriceText = cell.priceLabel.text,
               let addOnId = cell.addonId,
//               let addOnPrice = Int(addOnPriceText.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
               let addOnPrice = Double(addOnPriceText){
                let addOnInfo = "\(addOnName) (\(addOnPrice))"
                selectedAddOns.append(addOnInfo)
                selectedAddOnPrices.append(addOnPrice)
                selectedAddOnsForAPI.append(addOnInfo)
                selectedAddOnsId.append("\(addOnId)")
                let addOnToId = "\(addOnName) \(selectedItemId ?? 0)"
                selectedAddOnToItemId.append(addOnToId)
            }
        }
        
        
        let totalAddOnPrice = selectedAddOnPrices.reduce(0, +)
        let totalPrice = Double(sectionNameToPrice[segmentName] ?? 0) + totalAddOnPrice
        
        
        let selectedAddOnsString = selectedAddOns.joined(separator: "\n")
        let selectedItemIdsString = itemIdArr.joined(separator: "\n")
        let selectedItemNamesString = itemNameArr.joined(separator: "\n")
        let selectedAddOnsForPrice = selectedAddOnsForAPI.joined(separator: "\n")
        let selectedAddOnsIdsStr = selectedAddOnsId.joined(separator: "\n")
        let selectedAddOnToItemIdStr = selectedAddOnToItemId.joined(separator: "\n")
        
        let newItem: [String: String] = [
            "isDeals": "true",
            "DealName": titleWithPrice,
            "DealID": "\(self.dealId)",
            "BasePrice": "\(sectionNameToPrice[segmentName] ?? 0)",
            //"Title": selectedItemName ?? "",
            "Qty": quantity,
            "Price": "\(totalPrice)",
            "ItemId": selectedItemIdsString,
            "ItemName": selectedItemNamesString,
            "SelectedAddOnsId": selectedAddOnsIdsStr,
            "SelectedAddOnsForAPI": selectedAddOnToItemIdStr,
            "SelectedAddOnsForPrice": selectedAddOnsForPrice,
            "SelectedAddOns": selectedAddOnsString,
            "IsAddsOn": "true"
        ]
        if let existingSegment = savedItems.firstIndex(where: {$0["DealName"] == titleWithPrice}){
            savedItems[existingSegment]["SelectedAddOns"] = "\(selectedAddOnsString)"
            savedItems[existingSegment]["Price"] = "\(totalPrice)"
            savedItems[existingSegment]["ItemId"] = selectedItemIdsString
            savedItems[existingSegment]["ItemName"] = selectedItemNamesString
            savedItems[existingSegment]["IsAddsOn"] = "true"
            savedItems[existingSegment]["SelectedAddOnsForAPI"] = selectedAddOnToItemIdStr
            savedItems[existingSegment]["SelectedAddOnsForPrice"] = selectedAddOnsForPrice
            savedItems[existingSegment]["SelectedAddOnsId"] = selectedAddOnsIdsStr
        }
        else {
            savedItems.append(newItem)
        }
        UserDefaults.standard.set(savedItems, forKey: "newDealItem")
        clearSelectedAddOnIndexPaths()
        addOnscollectionView.reloadData()
        var totalValue = 0
        for (_, sectionName) in self.sectionNamesQTY.enumerated() {
            if let extractedIntValue = sectionName.extractIntFromParentheses(){
                totalValue = totalValue + extractedIntValue
            }
        }
        var selectedIndexpathinSegment = 0
        for (_, indexPaths) in selectedIndexPathsForSegments {
            selectedIndexpathinSegment += indexPaths.count
            }
        if let encodedData = try? PropertyListEncoder().encode(selectedIndexPathsForSegments) {
            UserDefaults.standard.set(encodedData, forKey: "selectedIndexPathsForSegments")
        }
        if let encodedData = try? PropertyListEncoder().encode(selectedIndexPaths) {
            UserDefaults.standard.set(encodedData, forKey: "selectedIndexPaths")
        }
        
        UserDefaults.standard.set(selectedIndexpathinSegment, forKey: "selectedIndexPathsForSegmentsCount")
        if selectedIndexpathinSegment == totalValue{
            //let newDeal = UserDefaults.standard.object(forKey: "newDealItem") as? [String:String] ?? [:]
            //savedItems.append(newDeal)
            var addedItem = UserDefaults.standard.array(forKey: "addedItems") as? [[String: String]] ?? []
            addedItem.append(savedItems.first ?? [:])
            UserDefaults.standard.set(addedItem, forKey: "addedItems")
            UserDefaults.standard.removeObject(forKey: "newDealItem")
        }
        
    }
    @IBAction func minusButton(_ sender: UIButton) {
        itemCount = max(1, itemCount - 1)
        updateItemCountLabel()
    }
    @IBAction func plusButton(_ sender: UIButton) {
        itemCount += 1
        updateItemCountLabel()
    }
    // MARK: Helper Methods
    func userDefaults() {
        if let savedData = UserDefaults.standard.data(forKey: "parsedDataKey"),
           let rows = try? JSONDecoder().decode([[MasterDetailRow]].self, from: savedData) {
            self.parsedRows = rows
        } else {
            // Handle the case where no data is saved in UserDefaults
        }
        var sectionNameToID: [String: Int] = [:]
        guard self.parsedRows.count > 6 else {
            // Handle the case where parsedRows doesn't have enough elements
            return
        }
        let rowItemData = self.parsedRows[6]
        let addOnsItemData = self.parsedRows[7]
        for dashboardModel in self.parsedRows {
            for row in dashboardModel {
                if let rowDealID = row.dealID, let rowcategoryID = row.categoryID, rowDealID == self.dealId {
                    if let sectionName = row.categoryName {
                        if !sectionNameToID.keys.contains(sectionName) {
                            sectionNameToID[sectionName] = rowcategoryID
                            self.sectionNames.append(sectionName)
                        }
                    }
                }
            }
        }
        segmentsFirstDeals.removeAllSegments()
        for dashboardModel in self.parsedRows {
            for row in dashboardModel {
                if let sectionID = row.dealID, let sectionName = row.dealName {
                    if !sectionNameToID.keys.contains(sectionName) {
                        sectionNameToID[sectionName] = sectionID
                        segmentsFirstDeals.insertSegment(withTitle: sectionName, at: segmentsFirstDeals.numberOfSegments, animated: false)
                        sectionNameToPrice[sectionName] = row.dealPrice
                    }
                    if let itemID = row.categoryID {
                        self.itemIDToSectionID[itemID] = sectionID
                    }
                }
            }
        }
        self.apiResponse = rowItemData
        self.apiResponseAddOns = addOnsItemData
        self.segments.removeAllSegments()
        self.sectionNameToID = sectionNameToID // Clear existing segments
        for (index, sectionName) in self.sectionNames.enumerated() {
            self.segments.insertSegment(withTitle: sectionName, at: index, animated: false)
        }
        self.segments.selectedSegmentIndex = 0
        self.itemcollectionView.reloadData()
        self.addOnscollectionView.reloadData()
    }
    func clearSelectedCells() {
        for indexPath in selectedIndexPaths {
            if let cell = itemcollectionView.cellForItem(at: indexPath) as? DealsCVCell {
                cell.cellView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }
        }
    }
    func clearSelectedAddOnIndexPaths() {
        selectedAddOnIndexPaths.removeAll()
        addOnscollectionView.reloadData()
    }
    func updateItemCountLabel() {
        itemViewLbl.text = String(itemCount)
    }
    func showSubView() {
        subView.isHidden = false
    }
    func hideSubView() {
        subView.isHidden = true
    }
    func updateItemSelectedLabel() {
        let uniqueSelectedItems = Set(selectedIndexPaths)
        let selectedItemCount = uniqueSelectedItems.count
        itemSelectedLbl.text = "\(selectedItemCount)"
    }
}
// MARK: Collection View
extension DealsVC:  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == itemcollectionView {
            guard segments.selectedSegmentIndex >= 0, segments.selectedSegmentIndex < sectionNames.count else {
                return 0
            }
            let selectedSectionID = sectionNameToID[sectionNames[segments.selectedSegmentIndex]] ?? -1
            let validItems = apiResponse.filter { item in
                return item.categoryID == selectedSectionID && item.itemName != nil
            }
            return validItems.count
        } else if collectionView == addOnscollectionView {
            guard let selectedItemName = selectedItemName else {
                return 0
            }
            // Filter matching add-ons based on selectedItemName
            let matchingAddOns = apiResponseAddOns.filter { $0.itemName == selectedItemName && $0.adsOnName != nil }
            return matchingAddOns.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == itemcollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DealsCVCell", for: indexPath) as! DealsCVCell
            let isSelected = selectedIndexPaths.contains(indexPath)
            if isSelected {
                cell.cellView.backgroundColor = #colorLiteral(red: 0.8596192002, green: 0.3426481783, blue: 0.2044148147, alpha: 1)
            } else {
                cell.cellView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }
            guard segments.selectedSegmentIndex < sectionNames.count else {
                cell.nameLabel?.text = nil
                //                cell.priceLabel?.text = nil
                cell.imagePath?.image = nil
                return cell
            }
            let selectedSectionID = sectionNameToID[sectionNames[segments.selectedSegmentIndex]] ?? -1
            let validItems = apiResponse.filter { item in
                return item.categoryID == selectedSectionID && item.itemName != nil
            }
            // Display item details in the cell
            if indexPath.row < validItems.count {
                let item = validItems[indexPath.row]
                cell.itemId = item.itemID
                cell.nameLabel?.text = item.itemName
                if let price = item.price {
                    cell.priceLabel?.text = "\(price)"
                }
                if let imagePath = item.imagePath, !imagePath.isEmpty {
                    cell.imagePath?.setImage(with: imagePath)
                } else {
                    cell.imagePath?.image = #imageLiteral(resourceName: "icons8-food-64")
                }
                let matchingAddOns = apiResponseAddOns.filter { addOnItem in
                    return addOnItem.itemName == item.itemName
                }
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddOnDealCVCell", for: indexPath) as! AddOnDealCVCell
            if let selectedItemName = selectedItemName {
                let matchingAddOns = apiResponseAddOns.filter { addOnItem in
                    return addOnItem.itemName == selectedItemName
                }
                if indexPath.row < matchingAddOns.count {
                    cell.nameLabel.text = matchingAddOns[indexPath.row].adsOnName
                    cell.addonId = matchingAddOns[indexPath.item].adsOnID
                    if let price = matchingAddOns[indexPath.row].price {
                        cell.priceLabel.text = "\(price)"
                    } else {
                        cell.priceLabel.text = "PKR: N/A"
                    }
                    
                }
            }
            if selectedAddOnIndexPaths.contains(indexPath) {
                cell.cellView.backgroundColor = #colorLiteral(red: 0.8596192002, green: 0.3426481783, blue: 0.2044148147, alpha: 1)
            } else {
                cell.cellView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            return cell
        }
    }
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == itemcollectionView {
            return CGSize(width: UIScreen.main.bounds.width/2 - 50, height: 100)
        }
        return CGSize(width: 175, height: 85)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateItemSelectedLabel()
        if collectionView == itemcollectionView {
            let selectedSegmentIndex = segments.selectedSegmentIndex
            var intValue: Int?
            //itemcollectionView.allowsMultipleSelection = false
            for (index, sectionName) in self.sectionNamesQTY.enumerated() {
                if let extractedIntValue = sectionName.extractIntFromParentheses(), index == selectedSegmentIndex {
                    intValue = extractedIntValue
                    print("Selected intValue: \(intValue ?? 0)")
                    let itemcellCount = (intValueSelectionCounts[intValue ?? 0] ?? 0) + 1
                    intValueSelectionCounts[intValue ?? 0] = itemcellCount
                    print("Count for \(intValue ?? 0): \(itemcellCount)")
                }
            }
            
            // Check if the cell is not already selected before updating the count
            if let intValue = intValue, !selectedIndexPaths.contains(indexPath), selectedIndexPaths.count < intValue {
                let itemcellCount = (intValueSelectionCounts[intValue] ?? 0)
                intValueSelectionCounts[intValue] = itemcellCount
                print("Count for \(intValue): \(itemcellCount)")
                //let maxItemCellCount = intValue // Change this to your desired value
                
                //                            if itemcellCount <= maxItemCellCount {
                
                //            if selectedIndexPathsForSegments[selectedSegmentIndex] == nil {
                //                selectedIndexPathsForSegments[selectedSegmentIndex] = []
                //            }
                // Append the selected index path for the current segment.
                if selectedIndexPathsForSegments[selectedSegmentIndex] == nil {
                        selectedIndexPathsForSegments[selectedSegmentIndex] = []
                    }
                selectedIndexPathsForSegments[selectedSegmentIndex]?.append(indexPath)
                
                
                if cellSelectionCountsForSegments[selectedSegmentIndex] == nil {
                    cellSelectionCountsForSegments[selectedSegmentIndex] = [:]
                }
                if let count = cellSelectionCountsForSegments[selectedSegmentIndex]?[indexPath] {
                    cellSelectionCountsForSegments[selectedSegmentIndex]?[indexPath] = count + 1
                } else {
                    cellSelectionCountsForSegments[selectedSegmentIndex]?[indexPath] = 1
                }
                hideSubView()
                showSubView()
                itemCount = 1
                updateItemCountLabel()
                selectedIndexPaths.append(indexPath)
                selectedItemIndexPath = indexPath
                
                if let cell = collectionView.cellForItem(at: indexPath) as? DealsCVCell {
                    selectedItemName = cell.nameLabel?.text
                    selectedItemPrice = cell.priceLabel?.text
                    selectedItemId = cell.itemId
                    subViewLbl.text = selectedItemName
                    subViewPriceLbl.text = selectedItemPrice
                    let matchingAddOns = apiResponseAddOns.filter { addOnItem in
                        return addOnItem.itemName == selectedItemName
                    }
                    if matchingAddOns.isEmpty {
                        hideSubView()
                        let segmentName = segmentsFirstDeals.titleForSegment(at: segmentsFirstDeals.selectedSegmentIndex) ?? ""
                        let titleWithPrice = "\(segmentName) - (\(sectionNameToPrice[segmentName] ?? 0))"
                        let totalAddOnPrice = selectedAddOnPrices.reduce(0, +)
                        let totalPrice = Double(sectionNameToPrice[segmentName] ?? 0) + totalAddOnPrice
                        var savedItems = UserDefaults.standard.array(forKey: "newDealItem") as? [[String: String]] ?? []
                        if let existingSegment = savedItems.firstIndex(where: {$0["DealName"] == titleWithPrice}){
                            selectedAddOns.append(selectedItemName ?? "")
                            itemNameArr.append(selectedItemName ?? "")
                            itemIdArr.append("\(selectedItemId ?? 0)")
                        }
                        else{
                            selectedAddOnToItemId.removeAll()
                            selectedAddOnsId.removeAll()
                            selectedAddOnsForAPI.removeAll()
                            selectedAddOns.removeAll()
                            selectedAddOnPrices.removeAll()
                            itemNameArr.removeAll()
                            itemIdArr.removeAll()
                            selectedAddOns.append(selectedItemName ?? "")
                            itemNameArr.append(selectedItemName ?? "")
                            itemIdArr.append("\(selectedItemId ?? 0)")
                        }
                        let selectedItemIdsString = itemIdArr.joined(separator: "\n")
                        let selectedItemNamesString = itemNameArr.joined(separator: "\n")
                        let selectedAddOnsString = selectedAddOns.joined(separator: "\n")
                        
                        let newItem: [String: String] = [
                            "isDeals": "true",
                            "DealID": String(dealId),
                            "DealName": titleWithPrice ,
                            //"Title": selectedItemName ?? "",
                            "BasePrice": "\(sectionNameToPrice[segmentName] ?? 0)",
                            "Price" : "\(totalPrice)",
                            "ItemId": selectedItemIdsString,
                            "ItemName": selectedItemNamesString,
                            "Qty": String(itemCountinCV),
                            "SelectedAddOns": selectedAddOnsString
                        ]
                        if let existingItemIndex = savedItems.firstIndex(where: { $0["itemName"] == selectedItemName }) {
                            if let existingItemINCV = Int(savedItems[existingItemIndex]["itemINCV"] ?? "0") {
                                savedItems[existingItemIndex]["itemINCV"] = String(existingItemINCV + 1)
                            }
                        }
//                        if let existingSegment = savedItems.firstIndex(where: {$0["DealID"] == String(dealId)}){
//                            let selectedAddOnsIdsStr = selectedAddOnsId.joined(separator: "\n")
//                            let selectedAddOnsForAPIStr = selectedAddOnToItemId.joined(separator: "\n")
//                            let selectedAddOnsForPrice = selectedAddOnsForAPI.joined(separator: "\n")
//                            savedItems[existingSegment]["SelectedAddOnsId"] = selectedAddOnsIdsStr
//                            savedItems[existingSegment]["SelectedAddOnsForAPI"] = selectedAddOnsForAPIStr
//                            savedItems[existingSegment]["SelectedAddOnsForPrice"] = selectedAddOnsForPrice
//                        }
//                        if let existingSegment = savedItems.firstIndex(where: {$0["DealName"] == titleWithPrice}){
//                            savedItems[existingSegment]["SelectedAddOns"] = "\(selectedAddOnsString)"
//                            savedItems[existingSegment]["Price"] = "\(totalPrice)"
//                            savedItems[existingSegment]["ItemId"] = selectedItemIdsString
//                            savedItems[existingSegment]["ItemName"] = selectedItemNamesString
//                        }
//                        if let existingSegment = savedItems.firstIndex(where: {$0["DealID"] == String(dealId)}){
//                            let selectedAddOnsIdsStr = selectedAddOnsId.joined(separator: "\n")
//                            let selectedAddOnsForAPIStr = selectedAddOnToItemId.joined(separator: "\n")
//                            let selectedAddOnsForPrice = selectedAddOnsForAPI.joined(separator: "\n")
//                            savedItems[existingSegment]["SelectedAddOnsId"] = selectedAddOnsIdsStr
//                            savedItems[existingSegment]["SelectedAddOnsForAPI"] = selectedAddOnsForAPIStr
//                            savedItems[existingSegment]["SelectedAddOnsForPrice"] = selectedAddOnsForPrice
//                        }
                        if let existingSegment = savedItems.firstIndex(where: {$0["DealName"] == titleWithPrice}){
                            savedItems[existingSegment]["SelectedAddOns"] = "\(selectedAddOnsString)"
                            savedItems[existingSegment]["Price"] = "\(totalPrice)"
                            savedItems[existingSegment]["ItemId"] = selectedItemIdsString
                            savedItems[existingSegment]["ItemName"] = selectedItemNamesString
                            
                        }
                        else {
                            
                            savedItems.append(newItem)
                        }
                        UserDefaults.standard.set(savedItems, forKey: "newDealItem")
                        
                        showToast(message: "You selected: \(selectedItemName ?? "")" , duration: 3.0)
                        UserDefaults.standard.set(true, forKey: "isDeals")
                        var totalValue = 0
                        for (_, sectionName) in self.sectionNamesQTY.enumerated() {
                            if let extractedIntValue = sectionName.extractIntFromParentheses(){
                                totalValue = totalValue + extractedIntValue
                            }
                        }
                        var selectedIndexpathinSegment = 0
                        for (_, indexPaths) in selectedIndexPathsForSegments {
                            selectedIndexpathinSegment += indexPaths.count
                            }
                        var totalIndexpath = 0
                        for (_, sectionName) in self.sectionNamesQTY.enumerated() {
                            if let extractedIntValue = sectionName.extractIntFromParentheses(){
                                totalIndexpath = totalIndexpath + extractedIntValue
                            }
                        }
                        UserDefaults.standard.set(totalIndexpath, forKey: "DealCount")
                        UserDefaults.standard.set(1, forKey: "selectedIndexPaths")
                        UserDefaults.standard.set(1, forKey: "selectedIndexPathsForSegments")
//                        if let encodedData = try? PropertyListEncoder().encode(selectedIndexPathsForSegments) {
//                            UserDefaults.standard.set(encodedData, forKey: "selectedIndexPathsForSegments")
//                        }
//                        if let encodedData = try? PropertyListEncoder().encode(selectedIndexPaths) {
//                            UserDefaults.standard.set(encodedData, forKey: "selectedIndexPaths")
//                        }
                        UserDefaults.standard.set(selectedIndexpathinSegment, forKey: "selectedIndexPathsForSegmentsCount")
                        if selectedIndexpathinSegment == totalValue{
                            //let newDeal = UserDefaults.standard.object(forKey: "newDealItem") as? [String:String] ?? [:]
                            //savedItems.append(newDeal)
                            var addedItem = UserDefaults.standard.array(forKey: "addedItems") as? [[String: String]] ?? []
                            addedItem.append(savedItems.first ?? [:])
                            UserDefaults.standard.set(addedItem, forKey: "addedItems")
                            UserDefaults.standard.removeObject(forKey: "newDealItem")
                        }
                    } else {
                        showSubView()
                    }
                    if !matchingAddOns.isEmpty {
                        let addOnNames = matchingAddOns.compactMap { $0.adsOnName }
                        var selectedAddOnNames: [String] = []
                        selectedAddOnNames.append(contentsOf: addOnNames)
                    }
                    addOnscollectionView.reloadData()
                }
                selectedItemIndexPath = indexPath
                collectionView.reloadItems(at: [indexPath])
                if let count = cellSelectionCounts[indexPath] {
                    cellSelectionCounts[indexPath] = count + 1
                }
                else {
                    cellSelectionCounts[indexPath] = 1
                }
                updateItemSelectedLabel()
            }
            else if selectedIndexPaths.contains(indexPath){
                if indexPath == selectedItemIndexPath {
                    intValueSelectionCounts = [:]
                    if let cell = itemcollectionView.cellForItem(at: indexPath) as? DealsCVCell {
                        // Deselect the item and update the UI
                        if let index = selectedIndexPaths.firstIndex(where: { $0 == indexPath }) {
                            selectedIndexPaths.remove(at: index)
                            cell.cellView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                            var savedItems = UserDefaults.standard.array(forKey: "addedItems") as? [[String: String]] ?? []
                            if let existingSegment = savedItems.firstIndex(where: {$0["DealID"] == String(dealId)}){
                                let index = selectedIndexPaths.firstIndex(of: indexPath) ?? 0
                                savedItems.remove(at: index)
                                UserDefaults.standard.set(savedItems, forKey: "addedItems")
                            }
                        }
                    }
                }
                hideSubView()
                clearSelectedAddOnIndexPaths()
                addOnscollectionView.reloadData()
                if selectedIndexPaths.count > 0 {
                    //selectedIndexPaths.removeLast()
                    updateItemSelectedLabel() // Update the label
                }
            }
            else {
                // If itemcellCount is more than the maximum allowed, do nothing
                print("Item count exceeds the maximum allowed.")
                //                    }
            }
        } else if collectionView == addOnscollectionView {
            if selectedAddOnIndexPaths.contains(indexPath) {
                selectedAddOnIndexPaths.remove(indexPath)
            } else {
                selectedAddOnIndexPaths.insert(indexPath)
            }
            collectionView.reloadItems(at: [indexPath])
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        if collectionView == itemcollectionView{
//            itemcollectionView.indexPathsForSelectedItems?.forEach{
//                itemcollectionView.deselectItem(at: $0, animated: false)
//            }
//        }
//        return true
//    }
}
extension String {
    func extractIntFromParentheses() -> Int? {
        let pattern = "\\((\\d+)\\)"
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
            
            if let match = matches.first, match.numberOfRanges > 1 {
                let range = match.range(at: 1)
                if let swiftRange = Range(range, in: self) {
                    let value = self[swiftRange]
                    return Int(value)
                }
            }
        } catch {
            print("Error in regular expression: \(error)")
        }
        
        return nil
    }
}
extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

extension DealsVC{
    func didRemoveDeal() {
        intValueSelectionCounts.removeAll()
        self.selectedIndexPaths.removeAll()
        self.selectedIndexPathsForSegments.removeAll()
        self.itemcollectionView.reloadData()
    }
}
