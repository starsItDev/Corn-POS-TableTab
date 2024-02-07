//
//  TabBarVC.swift
//  Corn Tab
//
//  Created by StarsDev on 11/07/2023.

import UIKit

class TabBarVC: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var dineInTabbar: UITabBarItem!
    @IBOutlet weak var takeaWayTabbar: UITabBarItem!
    @IBOutlet weak var dashboardTabbar: UITabBarItem!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableViewBtn: UIButton!
    @IBOutlet weak var collectionViewBtn: UIButton!
    @IBOutlet weak var loactionLbl: UILabel!
    @IBOutlet weak var attendNameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var pendingOrder: UILabel!
    
    //MARK: Variables
    var tableIDs: [String] = []
    var isActivityIndicatorVisible = false
    var orderDetail = [String]()
    var tableDetail = [String]()
    var customerIDsString = ""
    var distributionName = ""
    var userName = ""
    var workingDate = ""
    var dataSource: [Row] = []
    var timer: Timer?
    var refreshControl: UIRefreshControl!
    var orderIDA: String?
    var parsedRows: [[MasterDetailRow]] = []
    var dealNameToID: [Int: String] = [:]
    
    //MARK: Override Func
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Okkkkk")
        tabBar.selectedItem = dashboardTabbar
        let dineIn = UserDefaults.standard.integer(forKey: "Can_DineIn")
        if dineIn == 0{
            dineInTabbar.isEnabled = false
        }
        let takeAway = UserDefaults.standard.integer(forKey: "Can_TakeAway")
        if takeAway == 0{
            takeaWayTabbar.isEnabled = false
        }
        tabBar.delegate = self
        tableView.isHidden = true
        //        attendNameLbl.text = userName
        if let username = UserDefaults.standard.string(forKey: "UserName") {
            attendNameLbl.text = username
        }
        //        if let DistributionName = UserDefaults.standard.string(forKey: "DistributionName") {
        //            loactionLbl.text = DistributionName
        //        }
        if let WorkingDate = UserDefaults.standard.string(forKey: "WorkingDate") {
            dateLbl.text = WorkingDate
        }
        
        loactionLbl.text = distributionName
        //        dateLbl.text =  workingDate
        print(workingDate)
        UserDefaults.standard.set(workingDate, forKey: "savedWorkingDate")
        startTimer()
        // Initialize UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        makePOSTRequest()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        makePOSTRequest()
        userDefaults()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        makePOSTRequest()
    }
    func refreshTabBarVC() {
        makePOSTRequest() // Refresh your data or perform any necessary actions
    }
    
    @objc func refreshData() {
        // Perform your data refresh logic here, for example, make the POST request again
        makePOSTRequest()
    }
    
    func userDefaults() {
        if let savedData = UserDefaults.standard.data(forKey: "parsedDataKey"),
           let rows = try? JSONDecoder().decode([[MasterDetailRow]].self, from: savedData) {
            self.parsedRows = rows
        } else {
            // Handle the case where no data is saved in UserDefaults
        }
        
        
        for dashboardModel in self.parsedRows {
            for row in dashboardModel {
                //print(row)
                if let rowDealID = row.dealID{
                    dealNameToID[rowDealID] = row.dealName
                }
            }
        }
    }
    
    @IBAction func tableViewBtn(_ sender: UIButton) {
        tableView.isHidden = false
        collectionView.isHidden = true
        tableViewBtn.tintColor = #colorLiteral(red: 0.9657021165, green: 0.4859523773, blue: 0.2453393936, alpha: 1)
        collectionViewBtn.tintColor = #colorLiteral(red: 0.4576840401, green: 0.4979689717, blue: 0.5107063055, alpha: 1)
    }
    
    @IBAction func logOutBtnTap(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let logINVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(logINVC, animated: true)
    }
    
    @IBAction func collectionViewBtn(_ sender: UIButton) {
        collectionView.isHidden = false
        tableView.isHidden = true
        tableViewBtn.tintColor = #colorLiteral(red: 0.4576840401, green: 0.4979689717, blue: 0.5107063055, alpha: 1)
        collectionViewBtn.tintColor = #colorLiteral(red: 0.9657021165, green: 0.4859523773, blue: 0.2453393936, alpha: 1)
    }
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateDateAndTime), userInfo: nil, repeats: true)
    }
    @objc func updateDateAndTime() {
        let currentDate = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm:ss a"
        let dateString = timeFormatter.string(from: currentDate)
        timeLbl.text = dateString
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        //        dateLbl.text = dateFormatter.string(from: currentDate)
    }
    
    @objc func eidtBtnTapped(_ sender: UIButton) {
        if dataSource[sender.tag].orderDetail != nil{
            let jsonData = self.dataSource[sender.tag].orderDetail?.data(using: .utf8)
            do {
                // Use JSONDecoder to decode the data into an array of OrderItem
                let orderItems = try JSONDecoder().decode([OrderItem].self, from: jsonData!)
                
                // Now 'orderItems' contains an array of decoded OrderItem objects
                var savedItems = [[String: String]]()
                var allOrders = [OrderItem]()
                //var itemOrder = [OrderItem]()
                //var addonOrder = [Int: [OrderItem]]()
                var selectedAddOns: [String] = []
                var selectedAddOnPrices: [Double] = []
                var selectedAddOnIds: [String] = []
                var addOnIDWithItemID = [Int: [String]]()
                var modifierParentIds = [Int: [String]]()
                var totalAddOnPrices = [Int: [Double]]()
                var itemNameArr: [String] = []
                var itemIdArr: [String] = []
                var selectedAddOnToItemId: [String] = []
                var selectedAddOnsForAPI: [String] = []
                var isComplete = false
                var dealId = 0
                allOrders = orderItems
                for i in 0...allOrders.count - 1{
                    if dealId == allOrders[i].dealID || dealId == 0{
                        isComplete = false
                    }
                    else{
                        isComplete = true
                    }
                    if allOrders[i].isDeal == 0{
                        for j in 0...orderItems.count - 1{
                            
                            if allOrders[i].id == orderItems[j].modifierParentID && allOrders[i].modifierParentRowID == orderItems[j].modifierParentRowID{
                                
                                
                                let addOnInfo = "\(orderItems[j].name) (\(orderItems[j].price ?? 0))"
                                selectedAddOns.append(addOnInfo)
                                selectedAddOnPrices.append(orderItems[j].price ?? 0)
                                selectedAddOnIds.append("\(orderItems[j].id)")
                                modifierParentIds[orderItems[j].modifierParentID + (orderItems[j].modifierParentRowID ?? 0)] = selectedAddOns
                                totalAddOnPrices[orderItems[j].modifierParentID + (orderItems[j].modifierParentRowID ?? 0)] = selectedAddOnPrices
                                
                                addOnIDWithItemID[orderItems[j].modifierParentID + (orderItems[j].modifierParentRowID ?? 0)] = selectedAddOnIds
                            }
                            
                            
                        }
                        selectedAddOns.removeAll()
                        selectedAddOnPrices.removeAll()
                        selectedAddOnIds.removeAll()
                    }
                    
                    else{
                        if isComplete == true{
                            selectedAddOns.removeAll()
                            selectedAddOnPrices.removeAll()
                            selectedAddOnIds.removeAll()
                            selectedAddOnToItemId.removeAll()
                            selectedAddOnsForAPI.removeAll()
                            isComplete = false
                        }
                        if allOrders[i].isHasAddsOn || allOrders[i].isAddsOn{
                            if !allOrders[i].isAddsOn{
                                let itemInfo = "\(orderItems[i].name)"
                                let itemid = "\(orderItems[i].id)"
                                itemIdArr.append(itemid)
                                itemNameArr.append(itemInfo)
                                selectedAddOns.append(itemInfo)
                                //selectedAddOnIds.append("\(orderItems[i].id)")
                            }
                            for j in 0...orderItems.count - 1{
                                dealId = allOrders[i].dealID ?? 0
                                
                                if allOrders[i].id == orderItems[j].modifierParentID || allOrders[i].modifierParentID == orderItems[j].modifierParentRowID{
                                    
                                    let addOnInfo = "\(orderItems[j].name) (\(orderItems[j].price ?? 0))"
                                    selectedAddOns.append(addOnInfo)
                                    let addOnToId = "\(orderItems[j].name) \(orderItems[i].id)"
                                    //itemIdArr.append("\(orderItems[j].id)")
                                    //itemNameArr.append("\(orderItems[j].name)")
                                    selectedAddOnToItemId.append(addOnToId)
                                    selectedAddOnsForAPI.append(addOnInfo)
                                    
                                    selectedAddOnPrices.append(orderItems[j].price ?? 0)
                                    
                                    selectedAddOnIds.append("\(orderItems[j].id)")
                                    if isComplete == false{
                                        modifierParentIds[orderItems[j].dealID ?? 0] = selectedAddOns
                                        totalAddOnPrices[orderItems[j].dealID ?? 0] = selectedAddOnPrices
                                        
                                        addOnIDWithItemID[orderItems[j].dealID ?? 0] = selectedAddOnIds
                                        
                                    }
                                }
                            }
                            
                        }
                        else{
                            dealId = allOrders[i].dealID ?? 0
                            let addOnInfo = "\(orderItems[i].name)"
                            selectedAddOns.append(addOnInfo)
                            selectedAddOnPrices.append(orderItems[i].price ?? 0)
                            //selectedAddOnIds.append("\(orderItems[i].id)")
                            let itemInfo = "\(orderItems[i].name)"
                            let itemid = "\(orderItems[i].id)"
                            itemIdArr.append(itemid)
                            itemNameArr.append(itemInfo)
                            if isComplete == false{
                                modifierParentIds[orderItems[i].dealID ?? 0] = selectedAddOns
                                totalAddOnPrices[orderItems[i].dealID ?? 0] = selectedAddOnPrices
                                addOnIDWithItemID[orderItems[i].id ] = selectedAddOnIds
                            }
                           
                        }
                    }
                    
                }
                
                
                let totalAddOnPrice = selectedAddOnPrices.reduce(0, +)
                
                for orderItem in orderItems {
                    //print("OrderID: \(orderItem.orderID), Name: \(orderItem.name), Price: \(orderItem.price)")
                    
                    var totalPrice = Int()
                    var selectedAddOnsIdsStr = String()
                    if orderItem.isDeal == 1{
                        totalPrice = Int((orderItem.dealPrice ?? 0) + totalAddOnPrice)
                        if let addonIds = addOnIDWithItemID[orderItem.dealID ?? 0]{
                            selectedAddOnsIdsStr = addonIds.joined(separator: "\n")
                        }
                    }
                    else{
                        totalPrice = Int((orderItem.price ?? 0) + totalAddOnPrice)
                        if let addonIds = addOnIDWithItemID[orderItem.id + (orderItem.modifierParentRowID ?? 0)]{
                            selectedAddOnsIdsStr = addonIds.joined(separator: "\n")
                        }
                    }
                    if orderItem.isHasAddsOn{
                        var selectedAddOnsString = String()
                        if orderItem.isDeal == 1{
                            
                            let selectedAddOnToItemIdStr = selectedAddOnToItemId.joined(separator: "\n")
                            let selectedAddOnsForPrice = selectedAddOnsForAPI.joined(separator: "\n")
                            
                            if let addOnIds = modifierParentIds[orderItem.dealID ?? 0] {
                                selectedAddOnsString = addOnIds.joined(separator: "\n")
                            }
                            if let addOnPrices = totalAddOnPrices[orderItem.dealID ?? 0] {
                                totalPrice += Int(addOnPrices.reduce(0.0, +))
                            }
                            let selectedItemIdsString = itemIdArr.joined(separator: "\n")
                            let selectedItemNamesString = itemNameArr.joined(separator: "\n")
                            let newItem: [String: String] = [
                                "isDeals": "true",
                                "DealName": "\(orderItem.dealName) - (\(orderItem.dealPrice ?? 0))",
                                "ID": "\(orderItem.dealID ?? 0)",
                                "Qty": "\(Int(orderItem.dealQty ?? 0))",
                                "Price" : "\(totalPrice)",
                                "BasePrice": "\(orderItem.dealPrice ?? 0)",
                                "ItemId": selectedItemIdsString,
                                "ItemName": selectedItemNamesString,
                                "SelectedAddOns": "\(selectedAddOnsString)",
                                "SelectedAddOnsForAPI": selectedAddOnToItemIdStr,
                                "SelectedAddOnsForPrice": selectedAddOnsForPrice,
                                "IsAddsOn": "true",
                                "SelectedAddOnsId": selectedAddOnsIdsStr
                            ]
//                            if let existingSegment = savedItems.firstIndex(where: {$0["ID"] == "\(orderItem.dealID ?? 0)"}){
//                                savedItems[existingSegment]["SelectedAddOns"] = "\(str)"
//                                savedItems[existingSegment]["Price"] = "\(totalPrice)"
//                                                                savedItems[existingSegment]["ItemId"] = selectedItemIdsString
//                                                                savedItems[existingSegment]["ItemName"] = selectedItemNamesString
//                                savedItems[existingSegment]["IsAddsOn"] = "true"
//                                //                                savedItems[existingSegment]["SelectedAddOnsForAPI"] = selectedAddOnToItemIdStr
//                                savedItems[existingSegment]["Price"] = "\(totalPrice)"
//                                savedItems[existingSegment]["SelectedAddOnsId"] = selectedAddOnIdString
//                            }
                            if let existingSegment = savedItems.firstIndex(where: {$0["ID"] == "\(orderItem.dealID ?? 0)"}){
                                savedItems[existingSegment]["SelectedAddOns"] = "\(selectedAddOnsString)"
                                savedItems[existingSegment]["Price"] = "\(totalPrice)"
                                savedItems[existingSegment]["ItemId"] = selectedItemIdsString
                                savedItems[existingSegment]["ItemName"] = selectedItemNamesString
                                savedItems[existingSegment]["IsAddsOn"] = "true"
                                savedItems[existingSegment]["SelectedAddOnsForAPI"] = selectedAddOnToItemIdStr
                                savedItems[existingSegment]["SelectedAddOnsForPrice"] = selectedAddOnsForPrice
                                savedItems[existingSegment]["SelectedAddOnsId"] = selectedAddOnsIdsStr
                            }
                            else{
                                savedItems.append(newItem)
                            }
                            
                        }
                        else{
                            if let addOnIds = modifierParentIds[orderItem.id + (orderItem.modifierParentRowID ?? 0)] {
                                selectedAddOnsString = addOnIds.joined(separator: "\n")
                            }
                            
                            if let addOnPrices = totalAddOnPrices[orderItem.id + (orderItem.modifierParentRowID ?? 0)] {
                                totalPrice += Int(addOnPrices.reduce(0.0, +))
                            }
                            let newItem: [String: String] = [
                                "Title": "\(orderItem.name) - (\(orderItem.price ?? 0))",
                                "Qty": "\(Int(orderItem.qty ?? 0))",
                                "Price" : "\(totalPrice)",
                                "BasePrice": "\(orderItem.price ?? 0)",
                                "SelectedAddOns": "\(selectedAddOnsString)",
                                "IsAddsOn": "true",
                                "ID": "\(orderItem.id)",
                                "SelectedAddOnsId":selectedAddOnsIdsStr
                            ]
                            savedItems.append(newItem)
                        }
                    }
                    else if orderItem.isAddsOn{
                        
                    }
                    else{
                        if orderItem.isDeal == 1{
                            var str = String()
                            if let addOnIds = modifierParentIds[orderItem.dealID ?? 0] {
                                str = addOnIds.joined(separator: "\n")
                            }
                            if let addOnPrices = totalAddOnPrices[orderItem.dealID ?? 0] {
                                totalPrice += Int(addOnPrices.reduce(0.0, +))
                            }
                            let newItem: [String: String] = [
                                "isDeals": "true",
                                "DealName": "\(orderItem.dealName) - (\(orderItem.dealPrice ?? 0))",
                                "ID": "\(orderItem.dealID ?? 0)",
                                "Qty": "\(Int(orderItem.dealQty ?? 0))",
                                "Price" : "\(totalPrice)",
                                "BasePrice": "\(orderItem.dealPrice ?? 0)",
                                "SelectedAddOns": "\(str)",
                                "IsAddsOn": "true",
                                "SelectedAddOnsId":selectedAddOnsIdsStr
                            ]
                            if let existingSegment = savedItems.firstIndex(where: {$0["ID"] == "\(orderItem.dealID ?? 0)"}){
                                savedItems[existingSegment]["SelectedAddOns"] = "\(str)"
                                savedItems[existingSegment]["Price"] = "\(totalPrice)"
                                //                                savedItems[existingSegment]["ItemId"] = selectedItemIdsString
                                //                                savedItems[existingSegment]["ItemName"] = selectedItemNamesString
                                savedItems[existingSegment]["IsAddsOn"] = "true"
                                //                                savedItems[existingSegment]["SelectedAddOnsForAPI"] = selectedAddOnToItemIdStr
                                savedItems[existingSegment]["Price"] = "\(totalPrice)"
                                savedItems[existingSegment]["SelectedAddOnsId"] = selectedAddOnsIdsStr
                            }
                            else{
                                savedItems.append(newItem)
                            }
                        }
                        else{
                            let newItem: [String: String] = [
                                "Title": orderItem.name,
                                "Qty": "\(Int(orderItem.qty ?? 0))",
                                "Price" : "\(orderItem.price ?? 0)",
                                "SelectedAddOns": "",
                                "IsAddsOn": "false",
                                "ID": "\(orderItem.id)"
                            ]
                            
                            savedItems.append(newItem)
                        }
                    }
                    
                }
                let coverTable = dataSource[sender.tag].coverTable
                //let orderIDA = dataSource[sender.tag].orderID
                let dateTime = dataSource[sender.tag].createDateTime?.split(separator: "T")
                if dataSource[sender.tag].tableDetail != nil{
                    let jsonForTable = self.dataSource[sender.tag].tableDetail?.data(using: .utf8)
                    do{
                        let tableItems = try JSONDecoder().decode([TableItem].self, from: jsonForTable!)
                        if let firstTableDetail = tableItems.first {
                            let tableID = firstTableDetail.TableID
                            let tableName = firstTableDetail.TableName
                            let newItem: [String: Any] = [
                                
                                //"OrderNo": orderNo ,
                                "TableCover": coverTable ?? "",
                                "TableName" : tableName ?? "",
                                "Date": String(dateTime?[0] ?? ""),
                                "Time": String(dateTime?[1] ?? ""),
                                "isEdit": "\(true)"
                            ]
                            UserDefaults.standard.set(tableID, forKey: "EditedTableID")
                            UserDefaults.standard.set(newItem, forKey: "TableContent")
                        }
                    } catch{
                        print("Error decoding JSON: \(error)")
                    }
                }
                UserDefaults.standard.set(savedItems, forKey: "addedItems")
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        let orderNo = dataSource[sender.tag].orderNO
        let orderID = dataSource[sender.tag].orderID
        let tabBarController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeTabBar") as? UITabBarController
        if let nextViewController = tabBarController?.viewControllers?[2] as? OrderDetailsVC {
            nextViewController.isDeleteButtonHidden = true
            nextViewController.updatedButtonText = "Update Order"
            receivedTableIDs = tableIDs
            // Convert Int to String before assignment
            nextViewController.orderID = String(orderID)
            nextViewController.orderNo = orderNo
            
            print(orderID)
            
        }
        tabBarController?.delegate = self
        let navigationController = UINavigationController(rootViewController: tabBarController!)
        navigationController.modalPresentationStyle = .fullScreen
        if let viewControllers = tabBarController?.viewControllers, viewControllers.count >= 3 {
            tabBarController?.selectedIndex = 2
            //tabBarController.tableNumberText = tableNoLbl.text
            //tabBarController.coverTableText = coverTableLbl.text
        }
        self.present(navigationController, animated: false, completion: nil)
    }
}
//MARK: Helper function to make POST request
extension TabBarVC {
    func  makePOSTRequest() {
        let endpoint = APIConstants.Endpoints.dashBoard
        let urlString = APIConstants.baseURL + endpoint
        guard let apiUrl = URL(string: urlString) else {
            return
        }
        let parameters: [String: Any] = [
            "SpName": "IOS_GetPendingOrderOfflineMode",
            "Parameters": [
                "DistributorID": "1"]
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            // Create a URL request
            var request = URLRequest(url: apiUrl)
            request.httpMethod = "POST"
            let connString = UserDefaults.standard.string(forKey: "connectString")
            let accessToken = UserDefaults.standard.string(forKey: "Access_Token") ?? ""
            request.setValue(connString, forHTTPHeaderField: "x-conn")
            request.setValue("bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            // Create a URLSession data task
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print("Error: No data received")
                    return
                }
                // Decode the response into the DashBoardModel
                DispatchQueue.main.async {
                    do {
                        let decoder = JSONDecoder()
                        let dashboardModel = try decoder.decode(DashBoardModel.self, from: data).rows
                        let pendingOrder = try decoder.decode(DashBoardModel.self, from: data).totalLength
                        self.dataSource = dashboardModel
                        //                    DispatchQueue.main.async {
                        let date = dashboardModel.first?.createDateTime?.components(separatedBy: "T")
                        //                        self.dateLbl.text = date?[0] ?? ""
                        if let dateString = date?[0] {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "dd-MM-yyyy"
                            if let formattedDate = dateFormatter.date(from: dateString) {
                                self.dateLbl.text = dateFormatter.string(from: formattedDate)
                            }
                        }
                        self.pendingOrder.text = "\(pendingOrder)"
                        self.tableIDs = dashboardModel.compactMap { $0.tableID }
                        //                        self.collectionView.reloadData()
                        //                        self.tableView.reloadData()
                        //                        self.refreshControl.endRefreshing()
                        //}
                    } catch let error {
                        self.showToast(message: "Data Not Found")
                        self.dataSource = []
                        self.pendingOrder.text = "\(0)"
                        print("Error decoding API response: \(error)")
                    }
                    
                    //DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
                
            }
            task.resume()
        } catch {
            print("Error converting parameters to JSON data: \(error)")
        }
    }
}
//MARK: Collection View
extension TabBarVC:  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TabBarCVCell
        let rowData = dataSource[indexPath.item]
        
        if rowData.serviceTypeID == 3{
            cell.tableNoLbl.text = "Takeaway"
            cell.tableLbl.isHidden = true
            //cell.tableImg.image = #imageLiteral(resourceName: "Icon metro-bin")
        }
        else{
            cell.tableLbl.isHidden = false
            if let tableDetailData = rowData.tableDetail?.data(using: .utf8),
               let jsonArray = try? JSONSerialization.jsonObject(with: tableDetailData, options: []) as? [[String: Any]] {
                let tableNames = jsonArray.compactMap { $0["TableName"] as? String }
                let concatenatedNames = tableNames.joined(separator: "+")
                cell.tableNoLbl.text = concatenatedNames
            } else {
                cell.tableNoLbl.text = ""
            }
        }
        cell.orderNoLbl.text = rowData.orderNO
        
        var date = rowData.createDateTime?.components(separatedBy: "T")
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss.SSS"
        
        if let newTime = timeFormatter.date(from: date?[1] ?? "") {
            timeFormatter.dateFormat = "h:mm a"
            if let formattedTime = timeFormatter.string(for: newTime) {
                date?[1] = formattedTime
            } else {
                print("Failed to format time.")
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let newDate = dateFormatter.date(from: date?[0] ?? "") {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            if let formattedDate = dateFormatter.string(for: newDate) {
                date?[0] = formattedDate
            } else {
                print("Failed to format date.")
            }
        }
        
        cell.timeLbl.text = (date?[0] ?? "") + " " + (date?[1] ?? "")
        
        let displayDateFormatter = DateFormatter()
        displayDateFormatter.dateFormat = "dd-MM-yyyy h:mm a"
        
        if let currentDate = displayDateFormatter.date(from: cell.timeLbl.text ?? "") {
            // Calculate time ago
            let timeAgo = calculateTimeAgo(from: currentDate)
            cell.timeLbl.text = timeAgo
        }
        //        cell.tableNoLbl.text = rowData.tableDetail
        self.orderDetail.append(rowData.orderDetail ?? "")
        self.tableDetail.append(rowData.tableDetail ?? "")
        cell.eidtBtn.tag = indexPath.item
        cell.eidtBtn.addTarget(self, action: #selector(eidtBtnTapped(_:)), for: .touchUpInside)
        return cell
    }
    func calculateTimeAgo(from date: Date) -> String {
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: Date())
        
        if let year = components.year, year > 0 {
            return "\(year) year\(year == 1 ? "" : "s") ago"
        } else if let month = components.month, month > 0 {
            return "\(month) month\(month == 1 ? "" : "s") ago"
        } else if let day = components.day, day > 0 {
            return "\(day) day\(day == 1 ? "" : "s") ago"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour) hour\(hour == 1 ? "" : "s") ago"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute) minute\(minute == 1 ? "" : "s") ago"
        } else if let second = components.second, second > 0 {
            return "\(second) second\(second == 1 ? "" : "s") ago"
        } else {
            return "Just now"
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 270, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}
//MARK: Table  View
extension TabBarVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TabBarTVCell
        let rowData = dataSource[indexPath.section]
        if rowData.serviceTypeID == 3{
            cell.tableLbl.text = "Takeaway"
            cell.tableNoLbl.text = ""
        }
        else{
//            cell.tableNoLbl.isHidden = false
            if let tableDetailData = rowData.tableDetail?.data(using: .utf8),
               let jsonArray = try? JSONSerialization.jsonObject(with: tableDetailData, options: []) as? [[String: Any]] {
                // Extract table names and join them with a "+"
                let tableNames = jsonArray.compactMap { $0["TableName"] as? String }
                let concatenatedNames = tableNames.joined(separator: "+")
                
                cell.tableNoLbl.text = concatenatedNames
            } else {
                cell.tableNoLbl.text = "" // Handle invalid JSON data or missing TableName
            }
        }
        cell.orderNoLbl.text = rowData.orderNO
        
        var date = rowData.createDateTime?.components(separatedBy: "T")
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss.SSS"
        
        if let newTime = timeFormatter.date(from: date?[1] ?? "") {
            timeFormatter.dateFormat = "h:mm a"
            if let formattedTime = timeFormatter.string(for: newTime) {
                date?[1] = formattedTime
            } else {
                print("Failed to format time.")
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let newDate = dateFormatter.date(from: date?[0] ?? "") {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            if let formattedDate = dateFormatter.string(for: newDate) {
                date?[0] = formattedDate
            } else {
                print("Failed to format date.")
            }
        }
        
        cell.timeLbl.text = (date?[0] ?? "") + " " + (date?[1] ?? "")
        
        let displayDateFormatter = DateFormatter()
        displayDateFormatter.dateFormat = "dd-MM-yyyy h:mm a"
        
        if let currentDate = displayDateFormatter.date(from: cell.timeLbl.text ?? "") {
            // Calculate time ago
            let timeAgo = calculateTimeAgo(from: currentDate)
            cell.timeLbl.text = timeAgo
        }
        cell.editBtn.tag = indexPath.section
        cell.editBtn.addTarget(self, action: #selector(eidtBtnTapped(_:)), for: .touchUpInside)
        let spacing: CGFloat = 20
        cell.separatorInset = UIEdgeInsets(top: 0, left: spacing, bottom: 100, right: spacing)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
}
//MARK:  Extension Tabbar
extension TabBarVC:UITabBarControllerDelegate ,UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == dineInTabbar {
            let tabBarController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeTabBar") as? UITabBarController
            tabBarController?.delegate = self
            let navigationController = UINavigationController(rootViewController: tabBarController!)
            navigationController.modalPresentationStyle = .fullScreen
            if let selectionVC = tabBarController?.viewControllers?[1] as? SelectionVC {
//                selectionVC.receivedTableIDs = tableIDs
                receivedTableIDs = tableIDs
            }
            UserDefaults.standard.set(1, forKey: "ServiceTypeID")
            if let viewControllers = tabBarController?.viewControllers, viewControllers.count >= 1 {
                tabBarController?.selectedIndex = 1
                
            }
            
            self.present(navigationController, animated: false, completion: nil)
        }
        else if item == takeaWayTabbar {
            let tabBarController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeTabBar") as? UITabBarController
            tabBarController?.delegate = self
            let navigationController = UINavigationController(rootViewController: tabBarController!)
            navigationController.modalPresentationStyle = .fullScreen
            if let viewControllers = tabBarController?.viewControllers, viewControllers.count >= 3 {
                
                tabBarController?.selectedIndex = 3
            }
            UserDefaults.standard.set(3, forKey: "ServiceTypeID")
            if var viewControllers = tabBarController?.viewControllers {
                viewControllers.remove(at: 1)
                tabBarController?.viewControllers = viewControllers
            }
            self.present(navigationController, animated: false, completion: nil)
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 0 {
            makePOSTRequest()
            let addedItems = UserDefaults.standard.array(forKey: "addedItems") as? [[String: String]] ?? []
            
            if addedItems.isEmpty {
                // addedItems is empty, dismiss tabBarController without showing an alert
                tabBarController.dismiss(animated: false, completion: {
                    UserDefaults.standard.removeObject(forKey: "addedItems")
                    self.tabBar.selectedItem = self.dashboardTabbar
                })
            } else {
                // addedItems is not empty, show an alert
                let alert = UIAlertController(title: "Alert", message: "Do you want to discard your Order?", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    // Dismiss tabBarController and perform other actions
                    tabBarController.dismiss(animated: false, completion: {
                        UserDefaults.standard.removeObject(forKey: "addedItems")
                        self.tabBar.selectedItem = self.dashboardTabbar
                    })
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                    // Handle cancel button tap (you can leave it empty or perform additional actions)
                    print("")
                }
                
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                
                // Present the alert
                tabBarController.present(alert, animated: false, completion: nil)
            }
        }
        let isDeals = UserDefaults.standard.bool(forKey: "isDeals")
        let serviceId = UserDefaults.standard.integer(forKey: "ServiceTypeID")
        //var shouldSwitchToNewTab = false
        if serviceId == 1{
            if tabBarController.selectedIndex == 1 || tabBarController.selectedIndex == 2{
                if isDeals{
                    let intValue = UserDefaults.standard.integer(forKey: "DealCount")
                    let totalCount = UserDefaults.standard.integer(forKey: "selectedIndexPathsForSegmentsCount")
                    if totalCount < intValue && totalCount > 0{
                        
                        let alert = UIAlertController(title: "Alert", message: "Deal is incomplete", preferredStyle: .alert)
                        let continueAction = UIAlertAction(title: "Continue", style: .cancel) { _ in
                            self.dismiss(animated: true)
                        }
                        let removeAction = UIAlertAction(title: "Remove Deal", style: .default) { _ in
                            //                        tabBarController.selectedIndex = 3
                            UserDefaults.standard.removeObject(forKey: "newDealItem")
                            UserDefaults.standard.set(0, forKey: "selectedIndexPaths")
                            UserDefaults.standard.set(0, forKey: "selectedIndexPathsForSegments")
                            UserDefaults.standard.set(0, forKey: "DealCount")
                            UserDefaults.standard.set(0, forKey: "selectedIndexPathsForSegmentsCount")
                            
                        }
                        
                        alert.addAction(continueAction)
                        alert.addAction(removeAction)
                        tabBarController.present(alert, animated: false, completion: nil)
                    }
                }
            }
        }
        else if serviceId == 3{
            if tabBarController.selectedIndex == 1{
                if isDeals{
                    let intValue = UserDefaults.standard.integer(forKey: "DealCount")
                    let totalCount = UserDefaults.standard.integer(forKey: "selectedIndexPathsForSegmentsCount")
                    if totalCount < intValue && totalCount > 0{
                        let alert = UIAlertController(title: "Alert", message: "Deal is incomplete", preferredStyle: .alert)
                        let continueAction = UIAlertAction(title: "Continue", style: .cancel) { _ in
                            UserDefaults.standard.set(1, forKey: "selectedIndexPaths")
                            UserDefaults.standard.set(1, forKey: "selectedIndexPathsForSegments")
                            tabBarController.selectedIndex = 2
                        }
                        let removeAction = UIAlertAction(title: "Remove Deal", style: .default) { _ in
                            UserDefaults.standard.removeObject(forKey: "newDealItem")
                            UserDefaults.standard.set(0, forKey: "selectedIndexPaths")
                            UserDefaults.standard.set(0, forKey: "selectedIndexPathsForSegments")
                            UserDefaults.standard.set(0, forKey: "DealCount")
                            UserDefaults.standard.set(0, forKey: "selectedIndexPathsForSegmentsCount")
                        }
                        alert.addAction(continueAction)
                        alert.addAction(removeAction)
                        tabBarController.present(alert, animated: false, completion: nil)
                    }
                }
            }
        }
    }
}
