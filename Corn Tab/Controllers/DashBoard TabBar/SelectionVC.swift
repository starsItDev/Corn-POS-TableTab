//
//  SelectionVC.swift
//  Corn Tab
//
//  Created by StarsDev on 12/07/2023.

import UIKit
class SelectionVC: UIViewController{
    // MARK: Outlets
    @IBOutlet weak var segments: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var itemCountTxt: UITextField!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    //MARK: Var
    var itemCount = 1
    var receivedItemCount: Int = 0
    let textFieldDelegateHelper = TextFieldDelegateHelper()
    var apiResponse: [MasterDetailRow] = []
    var parsedRows: [[MasterDetailRow]] = []
    var sectionNames: [String] = []
    var itemIDToSectionID: [Int: Int] = [:]
    var sectionNameToID: [String: Int] = [:]
    var selectedTableNumbers: [String] = []
    var selectedIndexPaths: Set<IndexPath> = []
    var isSearchBarActive: Bool = false
    

    var filteredData: [MasterDetailRow] = []
    var searchBarValue:[MasterDetailRow] = []
    //var receivedTableIDs: [String] = []
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        collectionView.reloadData()
        apiCalling()
        itemCountTxt.keyboardType = .numberPad
        UserDefaults.standard.removeObject(forKey: "SelectedTableIDs")
       tableView.isHidden = true
    }
    
    private func setupUI() {
            navigationController?.setNavigationBarHidden(true, animated: false)
            let boldFont = UIFont.boldSystemFont(ofSize: 20)
            let attributes = [NSAttributedString.Key.font: boldFont]
            segments.setTitleTextAttributes(attributes, for: .normal)
            textFieldDelegateHelper.configureTapGesture(for: view)
            itemCountTxt.delegate = textFieldDelegateHelper
        itemCountTxt.delegate = self
            searchBar.delegate = self
        }
// MARK: Actions
        func apiCalling(){
            let loader = UIActivityIndicatorView(style: .large)
                loader.center = view.center
                loader.startAnimating()
                view.addSubview(loader)
            var sectionNameToID: [String: Int] = [:]
            
            APIManager.makePOSTRequest { dashboardModelArray in
                guard dashboardModelArray.count > 1 else {
//                    print("Error: dashboardModelArray has insufficient elements.")
//                    loader.stopAnimating()
//                    loader.removeFromSuperview()
                    return
                }
                self.searchBarValue = dashboardModelArray[0]
                let rowItemData = dashboardModelArray[1]
                for dashboardModel in dashboardModelArray {
                    for row in dashboardModel {
                            if let sectionID = row.floorID, let sectionName = row.floorName {
                                if !sectionNameToID.keys.contains(sectionName.rawValue) {
                                    sectionNameToID[sectionName.rawValue] = sectionID
                                    self.sectionNames.append(sectionName.rawValue)
                                }
                            if let itemID = row.floorID {
                                self.itemIDToSectionID[itemID] = sectionID
                            }
//                                print(self.searchBarValue)
                        }
                    }
                }
                DispatchQueue.main.async {
                            loader.stopAnimating()
                            loader.removeFromSuperview()
                            self.apiResponse = rowItemData
                            self.segments.removeAllSegments()
                            self.sectionNameToID = sectionNameToID

                            for (index, sectionName) in self.sectionNames.enumerated() {
                                self.segments.insertSegment(withTitle: sectionName, at: index, animated: false)
                            }
                            self.tableView.reloadData()
                            self.segments.selectedSegmentIndex = 0
                            self.collectionView.reloadData()
                        }
                    }
                }
    @IBAction func minusButton(_ sender: UIButton) {
        if let currentItemCount = Int(itemCountTxt.text ?? "1") {
            itemCount = max(1, currentItemCount - 1)
            updateItemCountLabel() // Update the item count label
            sendItemCountToDineInVC()
        }
    }
    @IBAction func plusButton(_ sender: UIButton) {
        if let currentItemCount = Int(itemCountTxt.text ?? "1") {
            itemCount = currentItemCount + 1
            updateItemCountLabel() // Update the item count label
            sendItemCountToDineInVC()
        }
    }
    func updateItemCountLabel() {
        itemCountTxt.text = String(itemCount)
    }
    @IBAction func segmentController(_ sender: UISegmentedControl) {
        selectedIndexPaths.removeAll()
        collectionView.reloadData()
    }
    func sendItemCountToDineInVC() {
        // Assuming that DineInVC is the fourth tab's view controller
        if let tabBarController = self.tabBarController,
           let dineInVC = tabBarController.viewControllers?[3] as? DineInVC {
//            dineInVC.receivedItemCount = String(itemCount)
            dineInVC.receivedItemCount = itemCountTxt.text
        }
        if let tabBarController = self.tabBarController,
           let orderDetailVC = tabBarController.viewControllers?[2] as? OrderDetailsVC {
//            orderDetailVC.coverTableText = String(itemCount)
            orderDetailVC.coverTableText = itemCountTxt.text
        }
    }
}
//MARK: Collection View
extension SelectionVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard segments.selectedSegmentIndex < sectionNames.count else {
            return 0
        }
        let selectedSectionID = sectionNameToID[sectionNames[segments.selectedSegmentIndex]] ?? -1
        let validItems = apiResponse.filter { item in
            return item.floorID == selectedSectionID && (item.tableNo != nil) && !receivedTableIDs.contains("\(item.tableID ?? 0)")
        }
        return validItems.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SelectionCVCell
        let selectedSectionIndex = segments.selectedSegmentIndex
        // Check if the selected segment index is within bounds
        if selectedSectionIndex >= 0 && selectedSectionIndex < sectionNames.count {
            let selectedSectionName = sectionNames[selectedSectionIndex]
            let selectedSectionID = sectionNameToID[selectedSectionName] ?? -1
            // Filter items based on the selected section's ID
            let sectionItems = apiResponse.filter { item in
                if let itemCategoryID = item.floorID {
                    return itemCategoryID == selectedSectionID
                    && (item.tableNo != nil)
                    && !receivedTableIDs.contains("\(item.tableID ?? 0)")
                }
                return false
            }
            // Check if indexPath.row is within bounds of sectionItems
            if indexPath.row < sectionItems.count {
                let item = sectionItems[indexPath.row]
                 cell.tableNumberLbl?.text = item.tableNo
                if selectedIndexPaths.contains(indexPath) {
                    cell.cellView.backgroundColor = #colorLiteral(red: 0.8596192002, green: 0.3426481783, blue: 0.2044148147, alpha: 1)
                } else {
                    cell.cellView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let selectedSegmentIndex = segments.selectedSegmentIndex
        if let cell = collectionView.cellForItem(at: indexPath) as? SelectionCVCell {
            if let selectedText = cell.tableNumberLbl.text {
                let selectedSegmentTitle = segments.titleForSegment(at: segments.selectedSegmentIndex)
                if let orderDetailVC = self.tabBarController?.viewControllers?[2] as? OrderDetailsVC{
                    orderDetailVC.tableNumberText = selectedText
                }
                let vc = self.tabBarController?.viewControllers?[3] as? DineInVC
                vc?.receivedLabelText = selectedText
                
                // Retrieve the item's tableID based on indexPath
                let selectedSectionIndex = segments.selectedSegmentIndex
                if selectedSectionIndex >= 0 && selectedSectionIndex < sectionNames.count {
                    let selectedSectionName = sectionNames[selectedSectionIndex]
                    let selectedSectionID = sectionNameToID[selectedSectionName] ?? -1
                    let sectionItems = apiResponse.filter { item in
                        if let itemCategoryID = item.floorID {
                            return itemCategoryID == selectedSectionID
                            && (item.tableNo != nil)
                            && !receivedTableIDs.contains("\(item.tableID ?? 0)")
                        }
                        return false
                    }
                    if indexPath.row < sectionItems.count {
                        let item = sectionItems[indexPath.row]
                        if let tableID = item.tableID {
                            var selectedTableIDs = UserDefaults.standard.string(forKey: "SelectedTableIDs") ?? ""
                            if !selectedTableIDs.isEmpty {
                                selectedTableIDs += ","
                            }
                            selectedTableIDs += "\(tableID)"
                            UserDefaults.standard.set(selectedTableIDs, forKey: "SelectedTableIDs")
                            UserDefaults.standard.synchronize()
                        }
                    }
                }
                if selectedIndexPaths.contains(indexPath) {
                    if let indexToRemove = selectedTableNumbers.firstIndex(of: selectedText) {
                        selectedTableNumbers.remove(at: indexToRemove)
                    }
                } else {
                    selectedTableNumbers.append(selectedText)
                }
                vc?.receivedSegmentTitle = selectedSegmentTitle
                vc?.receivedLabelText = selectedTableNumbers.joined(separator: " + ")
//                vc?.receivedItemCount = String(itemCount)
                vc?.receivedItemCount = itemCountTxt.text
            }
        }
        if selectedIndexPaths.contains(indexPath) {
            selectedIndexPaths.remove(indexPath)
        } else {
            selectedIndexPaths.insert(indexPath)
        }
        collectionView.reloadItems(at: [indexPath])
        if let tabBarController = self.tabBarController {
            let nextTabIndex = 3
            tabBarController.selectedIndex = nextTabIndex
        }
    }
}
//MARK: Extension Table View
extension SelectionVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBarIsEmpty() {
            return searchBarValue.count
        } else {
            return filteredData.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelectionTVCell

        var itemName: String
        var itemAddress: String
        var itemContact: String

        if searchBarIsEmpty() {
            if indexPath.row < searchBarValue.count {
                itemName = searchBarValue[indexPath.row].customerName ?? "N/A"
                itemAddress = searchBarValue[indexPath.row].address ?? "N/A"
                itemContact = searchBarValue[indexPath.row].primaryContact ?? "N/A"
            } else {
                itemName = "safdsafdsafadsfdsa"
                itemAddress = "N/A"
                itemContact = "N/A"
            }
        } else {
            if indexPath.row < filteredData.count {
                itemName = filteredData[indexPath.row].customerName ?? "N/allA"
                itemAddress = filteredData[indexPath.row].address ?? "N/allA"
                itemContact = filteredData[indexPath.row].primaryContact ?? "N/allA"
            } else {
                itemName = "N/A"
                itemAddress = "N/A"
                itemContact = "N/A"
            }
        }
                cell.nameLbl.text = searchBarIsEmpty() ? itemName : itemName
                cell.addressLbl.text = searchBarIsEmpty() ? itemAddress : itemAddress
                cell.phoneLbl.text = searchBarIsEmpty() ? itemContact : itemContact
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedCustomerName: String
        
        if searchBarIsEmpty() {
            if indexPath.row < searchBarValue.count {
                selectedCustomerName = searchBarValue[indexPath.row].customerName ?? "N/A"
            } else {
                selectedCustomerName = "N/A"
            }
        } else {
            if indexPath.row < filteredData.count {
                selectedCustomerName = filteredData[indexPath.row].customerName ?? "N/A"
            } else {
                selectedCustomerName = "N/A"
            }
        }

        
        searchBar.text = selectedCustomerName
        tableView.isHidden = true
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
//MARK: Extension SearchBar
extension SelectionVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearchBarActive = true
        tableView.isHidden = false
    }
    private func setSearchBarTextAttributes() {
            let searchBarTextField = searchBar.value(forKey: "searchField") as? UITextField

            // Set the font size to 25
            searchBarTextField?.font = UIFont.systemFont(ofSize: 25)

            // You can also set other text attributes if needed
            // searchBarTextField?.textColor = UIColor.yourTextColor
            // searchBarTextField?.backgroundColor = UIColor.yourBackgroundColor
        }

        // Call this function where you initialize your search bar, such as in viewDidLoad
        private func setupSearchBar() {
            searchBar.delegate = self
            setSearchBarTextAttributes()
            // Other setup code for your search bar
        }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterTableView(for: searchText)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchBarActive = false
        tableView.isHidden = true

        searchBar.text = nil
        searchBar.resignFirstResponder()
        filterTableView(for: "")
    }
    private func searchBarIsEmpty() -> Bool {
        return searchBar.text?.isEmpty ?? true
    }

    private func filterTableView(for searchText: String) {
        if searchBarIsEmpty() {
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
            if isSearchBarActive {
                filteredData = searchBarValue.filter { $0.customerName?.lowercased().contains(searchText.lowercased()) ?? false }
            } else {
                // Show all data when the search bar is not active
                filteredData = searchBarValue
            }
            tableView.reloadData()
        }
    }
}

extension SelectionVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == itemCountTxt{
            if let tabBarController = self.tabBarController,
               let dineInVC = tabBarController.viewControllers?[3] as? DineInVC {
    //            dineInVC.receivedItemCount = String(itemCount)
                dineInVC.receivedItemCount = itemCountTxt.text
            }
            if let tabBarController = self.tabBarController,
               let orderDetailVC = tabBarController.viewControllers?[2] as? OrderDetailsVC {
    //            orderDetailVC.coverTableText = String(itemCount)
                orderDetailVC.coverTableText = itemCountTxt.text
            }
        }
        return true
    }
}
