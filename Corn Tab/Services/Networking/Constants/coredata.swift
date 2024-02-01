////
////  coredata.swift
////  Corn Tab
////
////  Created by StarsDev on 15/08/2023.
////
//import Foundation
//import CoreData
//
//@objc(MasterDetailModelEntity1)
//public class MasterDetailModelEntity1: NSManagedObject {
//    @NSManaged var totalLength: Int32
//    @NSManaged var status: Bool
//    @NSManaged var rows: Set<MasterDetailRowEntity1>
//}
//
//@objc(MasterDetailRowEntity1)
//public class MasterDetailRowEntity1: NSManagedObject {
//    @NSManaged var distributorID: Int32
//    @NSManaged var customerID: NSNumber?
//    @NSManaged var customerCode: String?
//    @NSManaged var customerName: String?
//    @NSManaged var address: String?
//    // Add other properties as needed
//
//    func configure(from row: MasterDetailRow) {
//        distributorID = Int32(row.distributorID ?? 0)
//        customerID = row.customerID as NSNumber?
//        customerCode = row.customerCode
//        customerName = row.customerName
//        address = row.address
//        // Set other properties accordingly
//    }
//}
//
//
//import UIKit
//import CoreData
//
//class APIManagerDataBase {
//    static func makePOSTRequestAndSave(completion: @escaping (Error?) -> Void) {
//        let endpoint = APIConstants.Endpoints.masterDetail
//        let urlString = APIConstants.baseURL + endpoint
//        guard let apiUrl = URL(string: urlString) else {
//            print("Invalid URL.")
//            return
//        }
//        // Define the request parameters as a dictionary
//        let parameters: [String: Any] = [
//            "SpName": "uspGetAllMasterDataApi",
//            "Parameters": [
//                "DistributorID": "1"]
//        ]
//        // Convert parameters to JSON data
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
//            // Create a URL request
//            var request = URLRequest(url: apiUrl)
//            request.httpMethod = "POST"
//            let connString = UserDefaults.standard.string(forKey: "connectString")
//            let accessToken = UserDefaults.standard.string(forKey: "Access_Token") ?? ""
//            request.setValue(connString, forHTTPHeaderField: "x-conn")
//            request.setValue("bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.httpBody = jsonData
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                guard let data = data else {
//                    print("Error: No data received")
//                    completion(error)
//                    return
//                }
//
//                do {
//                    let decoder = JSONDecoder()
//                    let dashboardModel = try decoder.decode(MasterDetailModel.self, from: data)
//
//                    let context: NSManagedObjectContext = CoreDataManager.shared.context
//
//                    let newMasterDetail = MasterDetailModelEntity1(context: context)
//                    newMasterDetail.totalLength = Int32(dashboardModel.totalLength)
//                    newMasterDetail.status = dashboardModel.status
//
//                    for row in dashboardModel.rows {
//                        for r in row {
//                            let newRow = MasterDetailRowEntity1(context: context)
//                            newRow.configure(from: r)
////                            newMasterDetail.addToRows(newRow) // Associate the new row with the master detail entity
//                        }
//                    }
//
//                    do {
//                        // Save the context
//                        try context.save()
//                        completion(nil)
//                    } catch {
//                        completion(error)
//                    }
//                } catch {
//                    completion(error)
//                }
//            }
//            task.resume()
//
//        } catch {
//            completion(error)
//        }
//    }
//}
//class CoreDataManager {
//    static let shared = CoreDataManager() // Singleton instance
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//    func fetchMasterDetailRows(filteredBy predicate: NSPredicate? = nil, sortedBy sortDescriptors: [NSSortDescriptor]? = nil) -> [MasterDetailRowEntity1] {
//        let fetchRequest: NSFetchRequest<MasterDetailRowEntity1> = NSFetchRequest(entityName: "MasterDetailRowEntity1")
//
//        fetchRequest.predicate = predicate
//        fetchRequest.sortDescriptors = sortDescriptors
//
//        do {
//            let rows = try context.fetch(fetchRequest)
//            return rows
//        } catch {
//            print("Error fetching rows: \(error)")
//            return []
//        }
//    }
//}
//
//
//  DineInVC.swift
//  Corn Tab
//
//  Created by Ali Sher on 12/07/2023.




//
//import UIKit
//import CoreData
//class DineInVC: UIViewController,UITextFieldDelegate{
//    // MARK: Outlets
//
//    @IBOutlet weak var scrollView: UIScrollView!
//
//    @IBOutlet weak var segments: UISegmentedControl!
//    @IBOutlet weak var collectionView: UICollectionView!
//    @IBOutlet weak var itemViewLbl: UILabel!
//    @IBOutlet weak var subView: UIView!
//    @IBOutlet weak var itemSelectedLbl: UILabel!
//    @IBOutlet weak var subViewBtn1: UIButton!
//    @IBOutlet weak var subViewBtn2: UIButton!
//    @IBOutlet weak var subViewBtn3: UIButton!
//    @IBOutlet weak var searchField: UITextField!
//    @IBOutlet weak var subViewLbl: UILabel!
//    @IBOutlet weak var subViewPriceLbl: UILabel!
//    @IBOutlet weak var floorLbl: UILabel!
//    @IBOutlet weak var tableNoLbl: UILabel!
//    @IBOutlet weak var titleLbl: UILabel!
//    @IBOutlet weak var fullLbl: UILabel!
//    @IBOutlet weak var quntityLbl: UILabel!
//    // MARK: Properties
//
//    var sectionNames: [String] = []
//
//    var receivedLabelText: String?
//    var receivedSegmentTitle: String?
//    var itemCount = 0
//    var selectedBtnIndex: Int = 0
//    var selectedIndexPaths: [IndexPath] = []
//    var lastSelectedIndexPath: IndexPath?
//    var dishSelectedIndexPaths: [IndexPath] = []
//    var fullMenuSelectedIndexPaths: [IndexPath] = []
//    var drinksSelectedIndexPath: [IndexPath] = []
//    var row6DataArray: [MasterDetailRow] = []
//    var row8DataArray: [MasterDetailRow] = []
//    var row5DataArray: [MasterDetailRow] = []
//    var fetchedData: [MasterDetailEntity] = []
//
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
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        hideSubView()
//        searchField.delegate = self
//    }
//    override func viewWillAppear(_ animated: Bool) {
////     masterAPICall()
//        retrieveAndPrintSectionName()
//        searchField.delegate = self
//        if let labelText = receivedLabelText {
//            tableNoLbl.text = ":\(labelText)"
//        }
//        if let segment = receivedSegmentTitle, let text = receivedLabelText {
//            floorLbl.text = "\(segment)\nSelected Text: \(text)"
//        }
//
//        fetchedData = CoreDataHelper.retrieveData()
//        print(fetchedData)
//        for item in fetchedData {
//            if let dealName = item.tableNo, !dealName.isEmpty {
//                       print("Deal Name: \(dealName)")
//                   }
//               }
//            self.collectionView.reloadData()
//    }
//    // MARK: Actions
////    func masterAPICall() {
////        APIManager.makePOSTRequest { rows in
////            guard rows.count > 15 else {
////                return
////            }
////            let row5Data = rows[5]
////            let row6Data = rows[6]
////            let row8Data = rows[8]
////
////            DispatchQueue.main.async {
////                // Assuming you have separate arrays to hold data for each row
////                self.row6DataArray = row6Data
////                self.row8DataArray = row8Data
////                self.row5DataArray = row5Data
////                self.collectionView.reloadData()
////            }
////        }
////    }
//    func retrieveAndPrintSectionName() {
//        var sectionNameToID: [String: Int] = [:]  // Store section names and their corresponding IDs
//
//        APIManager.makePOSTRequest { dashboardModelArray in
//            // Assuming dashboardModelArray is a 2D array, so we'll iterate over each inner array
//            for dashboardModel in dashboardModelArray {
//                for row in dashboardModel {
//                    if let sectionID = row.sectionID, let sectionName = row.sectionName {
//                        if !sectionNameToID.keys.contains(sectionName.rawValue) {
//                            sectionNameToID[sectionName.rawValue] = sectionID
//                            self.sectionNames.append(sectionName.rawValue)
//                        }
//                    }
//                }
//            }
//            // Update the segment titles with the retrieved section names
//            DispatchQueue.main.async {
//                self.segments.removeAllSegments()  // Clear existing segments
//                for (index, sectionName) in self.sectionNames.enumerated() {
//                    self.segments.insertSegment(withTitle: sectionName, at: index, animated: false)
//                }
//                self.segments.selectedSegmentIndex = 0  // Select the first segment
//            }
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
//            let segmentWidth = scrollView.contentSize.width / CGFloat(segments.numberOfSegments - 1)
//            var xOffset: CGFloat = 0
//            if selectedSegmentIndex < segments.numberOfSegments - 4 {
//                xOffset = max(0, segmentWidth * CGFloat(selectedSegmentIndex) - 400)
//            } else {
//                xOffset = scrollView.contentSize.width - scrollView.frame.width
//            }
//        scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
//
//
//        itemCount = 0
//        updateItemCountLabel()
//        collectionView.reloadData()
//    }
//    @IBAction func closeButton(_ sender: UIButton) {
//        hideSubView()
//        itemCount = 0
//        updateItemCountLabel()
//        if let lastSelectedIndexPath = lastSelectedIndexPath {
//            let lastSelectedCell = collectionView.cellForItem(at: lastSelectedIndexPath) as? DineInCVCell
//
//            if segments.selectedSegmentIndex == 0 {
//                if let index = dishSelectedIndexPaths.firstIndex(of: lastSelectedIndexPath) {
//                    dishSelectedIndexPaths.remove(at: index)
//                }
//            } else if segments.selectedSegmentIndex == 1 {
//                if let index = fullMenuSelectedIndexPaths.firstIndex(of: lastSelectedIndexPath) {
//                    fullMenuSelectedIndexPaths.remove(at: index)
//                }
//            }
//            else if segments.selectedSegmentIndex == 2 {
//                if let index = drinksSelectedIndexPath.firstIndex(of: lastSelectedIndexPath) {
//                    drinksSelectedIndexPath.remove(at: index)
//                }
//            }
//            lastSelectedCell?.cellView.backgroundColor = UIColor.gray
//            self.lastSelectedIndexPath = nil
//
//            collectionView.reloadItems(at: [lastSelectedIndexPath])
//        }
//    }
//    @IBAction func addToOrder(_ sender: UIButton) {
//        if itemCount > 0 {
//            updateCountLabel()
//            let title = titleLbl.text ?? ""
//            let fullText = fullLbl.text ?? ""
//            let quantity = quntityLbl.text ?? ""
//            let price = subViewPriceLbl.text ?? ""
//            let newItem: [String: String] = [
//                "title": title,
//                "fullText": fullText,
//                "quantity": quantity,
//                "price" : price
//            ]
//            var savedItems = UserDefaults.standard.array(forKey: "addedItems") as? [[String: String]] ?? []
//            savedItems.append(newItem)
//            UserDefaults.standard.set(savedItems, forKey: "addedItems")
//
//        } else {
//            let alert = UIAlertController(title: "Error", message: "Please select items to add to the order.", preferredStyle: .alert)
//            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
//            alert.addAction(okayAction)
//            present(alert, animated: true, completion: nil)
//        }
//    }
//    @IBAction func minusButton(_ sender: UIButton) {
//        itemCount = max(0, itemCount - 1)
//        updateItemCountLabel()
//    }
//    @IBAction func plusButton(_ sender: UIButton) {
//        itemCount += 1
//        updateItemCountLabel()
//    }
//    @IBAction func buttonOne(_ sender: UIButton) {
//        updateSubViewButtonImages(selectedButtonIndex: 0)
//        selectedBtnIndex = 0
//    }
//    @IBAction func buttonTwo(_ sender: UIButton) {
//        updateSubViewButtonImages(selectedButtonIndex: 1)
//        selectedBtnIndex = 1
//    }
//    @IBAction func buttonthree(_ sender: UIButton) {
//        updateSubViewButtonImages(selectedButtonIndex: 2)
//        selectedBtnIndex = 2
//    }
//    // MARK: Helper Methods
//    func updateItemCountLabel() {
//        itemViewLbl.text = String(itemCount)
//    }
//    func updateSubViewButtonImages(selectedButtonIndex: Int) {
//        subViewBtn1.setImage(selectedButtonIndex == 0 ? UIImage(named: "black") : UIImage(named: "white"), for: .normal)
//        subViewBtn2.setImage(selectedButtonIndex == 1 ? UIImage(named: "black") : UIImage(named: "white"), for: .normal)
//        subViewBtn3.setImage(selectedButtonIndex == 2 ? UIImage(named: "black") : UIImage(named: "white"), for: .normal)
//    }
//    func showSubView() {
//        subView.isHidden = false
//    }
//    func hideSubView() {
//        subView.isHidden = true
//    }
//}
//// MARK: Collection View
//extension DineInVC:  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch segments.selectedSegmentIndex {
//        case 0:
//            return fetchedData.count
//        case 1:
//            return fetchedData.count
//        case 2:
//            return row5DataArray.count
//        default:
//            return 0
//        }
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DineInCVCell
//
//        switch segments.selectedSegmentIndex {
//        case 0:
//            cell.cellView.backgroundColor = dishSelectedIndexPaths.contains(indexPath) ? UIColor.orange : UIColor.gray
//            let item = fetchedData[indexPath.item]
//                    if let dealName = item.dealName, !dealName.isEmpty {
//                        cell.nameLabel.text = dealName
//                    }
//        case 1:
//            cell.cellView.backgroundColor = fullMenuSelectedIndexPaths.contains(indexPath) ? UIColor.orange : UIColor.gray
//            let item = fetchedData[indexPath.item]
//            if let itemName = item.itemName, !itemName.isEmpty {
//                        cell.nameLabel.text = itemName
//                    }
//                    if item.price != 0 { // Assuming 0 is the default value for Int32
//                        let priceText = "Price: \(item.price)"
//                        cell.priceLabel.text = priceText
//                    } else {
//                        cell.priceLabel.text = "" // Or handle the case when price is 0
//                    }
////            if indexPath.row < row6DataArray.count {
////                let item = row6DataArray[indexPath.row]
////                cell.nameLabel?.text = item.itemName
////                cell.priceLabel?.text = item.price != nil ? "\(item.price!)" : "N/A"
////            }
//        case 2:
//            cell.cellView.backgroundColor = drinksSelectedIndexPath.contains(indexPath) ? UIColor.orange : UIColor.gray
//            if indexPath.row < row5DataArray.count {
//                let item = row5DataArray[indexPath.row]
//                cell.nameLabel?.text = item.category
//            }
////            let item = fetchedData[indexPath.item]
////            if let category = item.category, !category.isEmpty {
////                        cell.nameLabel.text = category
////                    }
//        default:
//            break
//        }
//        return cell
//    }
//    // MARK: UICollectionViewDelegate
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if segments.selectedSegmentIndex == 0 {
//            if let index = dishSelectedIndexPaths.firstIndex(of: indexPath) {
//                dishSelectedIndexPaths.remove(at: index)
//                updateCountLabel()
//            } else {
//                dishSelectedIndexPaths.append(indexPath)
//                showSubView()
//            }
//        } else if segments.selectedSegmentIndex == 1 {
//            if let index = fullMenuSelectedIndexPaths.firstIndex(of: indexPath) {
//                fullMenuSelectedIndexPaths.remove(at: index)
//                updateCountLabel()
//            } else {
//                fullMenuSelectedIndexPaths.append(indexPath)
//                showSubView()
//            }
//        }
//        else if segments.selectedSegmentIndex == 2 {
//            if let index = drinksSelectedIndexPath.firstIndex(of: indexPath) {
//                drinksSelectedIndexPath.remove(at: index)
//                updateCountLabel()
//            } else {
//                drinksSelectedIndexPath.append(indexPath)
//                showSubView()
//            }
//        }
//        if let lastSelectedIndexPath = lastSelectedIndexPath, lastSelectedIndexPath != indexPath {
//            itemCount = 0
//            updateItemCountLabel()
//        }
//        subViewBtn1.setImage(UIImage(named: "white"), for: .normal)
//        subViewBtn2.setImage(UIImage(named: "white"), for: .normal)
//        subViewBtn3.setImage(UIImage(named: "white"), for: .normal)
//        lastSelectedIndexPath = indexPath
//        collectionView.reloadItems(at: [indexPath])
//        let cellName: String
//        let price: String
//        switch segments.selectedSegmentIndex {
//        case 0:
//            if indexPath.row < row8DataArray.count {
//                cellName = row8DataArray[indexPath.row].dealName ?? "Default Name"
//                if let itemPrice = row8DataArray[indexPath.row].dealPrice {
//                    price = "\(itemPrice)"
//                } else {
//                    price = "N/A"
//                }
//            } else {
//                cellName = "Invalid Item"
//                price = ""
//            }
//        case 1:
//            if indexPath.row < row6DataArray.count {
//                cellName = row6DataArray[indexPath.row].itemName ?? "Default Name"
//                if let itemPrice = row6DataArray[indexPath.row].price {
//                    price = "\(itemPrice)"
//                } else {
//                    price = "N/A"
//                }
//            } else {
//                cellName = "Invalid Item"
//                price = ""
//            }
//        case 2:
//            if indexPath.row < row5DataArray.count {
//                cellName = row5DataArray[indexPath.row].itemName ?? "Default Name"
//                if let itemPrice = row5DataArray[indexPath.row].price {
//                    price = "\(itemPrice)"
//                } else {
//                    price = "N/A"
//                }
//            } else {
//                cellName = "Invalid Item"
//                price = ""
//            }        default:
//            cellName = ""
//            price = ""
//        }
//        subViewLbl.text = cellName
//        subViewPriceLbl.text = "Rs: \(price)"
//    }
//    private func updateCountLabel() {
//        let totalCount = dishSelectedIndexPaths.count + fullMenuSelectedIndexPaths.count + drinksSelectedIndexPath.count
//        itemSelectedLbl.text = "\(totalCount)"
//        hideSubView()
//    }
//}
//
