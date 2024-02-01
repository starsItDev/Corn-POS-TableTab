

import Foundation
import UIKit

//class APIManager {
//
//    static let dataExpirationInterval: TimeInterval = 1 * 60 // 30 minutes in seconds
//
//    static func makePOSTRequest(completion: @escaping ([[MasterDetailRow]]) -> Void) {
//        let endpoint = APIConstants.Endpoints.masterDetail
//        let urlString = APIConstants.baseURL + endpoint
//
//        guard let apiUrl = URL(string: urlString) else {
//            print("Invalid URL.")
//            return
//        }
//
//        let currentTimeStamp = Date().timeIntervalSince1970
//
//        // Check if the data in UserDefaults is still valid
//        if let storedDataTimeStamp = UserDefaults.standard.object(forKey: "dataTimeStamp") as? Double,
//           currentTimeStamp - storedDataTimeStamp < dataExpirationInterval,
//           let storedData = UserDefaults.standard.data(forKey: "parsedDataKey") {
//            do {
//                let decoder = JSONDecoder()
//                let dashboardModel = try decoder.decode(MasterDetailModel.self, from: storedData)
//                completion(dashboardModel.rows.compactMap { $0 })
//                return
//            } catch {
//                print("Error decoding stored JSON: \(error)")
//            }
//        }
//
//        let parameters: [String: Any] = [
//            "SpName": "uspGetAllMasterDataApi",
//            "Parameters": [
//                "DistributorID": "1"
//            ]
//        ]
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
//
//            var request = URLRequest(url: apiUrl)
//            request.httpMethod = "POST"
//
//            let connString = UserDefaults.standard.string(forKey: "connectString")
//            let accessToken = UserDefaults.standard.string(forKey: "Access_Token") ?? ""
//
//            request.setValue(connString, forHTTPHeaderField: "x-conn")
//            request.setValue("bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.httpBody = jsonData
//
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                guard let data = data else {
//                    print("Error: No data received")
//                    completion([])
//                    return
//                }
//
//                do {
//                    let decoder = JSONDecoder()
//                    let dashboardModel = try decoder.decode(MasterDetailModel.self, from: data)
//
//                    // Save data to UserDefaults along with the timestamp
//                    let dataToSave = try JSONEncoder().encode(dashboardModel.rows)
//                    UserDefaults.standard.set(dataToSave, forKey: "parsedDataKey")
//                    UserDefaults.standard.set(currentTimeStamp, forKey: "dataTimeStamp")
//
//                    completion(dashboardModel.rows.compactMap { $0 })
//                } catch {
//                    print("Error decoding JSON: \(error)")
//                    completion([])
//                }
//            }
//            task.resume()
//        } catch {
//            print("Error converting parameters to JSON data: \(error)")
//        }
//    }
//}


class APIManager {

    static func makePOSTRequest(completion: @escaping ([[MasterDetailRow]]) -> Void) {
        let endpoint = APIConstants.Endpoints.masterDetail
        let urlString = APIConstants.baseURL + endpoint

        guard let apiUrl = URL(string: urlString) else {
            print("Invalid URL.")
            return
        }
        let parameters: [String: Any] = [
            "SpName": "IOS_GetAllMasterDataAPI",
            "Parameters": [
                "DistributorID": "1"
            ]
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])

            var request = URLRequest(url: apiUrl)
            request.httpMethod = "POST"

            let connString = UserDefaults.standard.string(forKey: "connectString")
            let accessToken = UserDefaults.standard.string(forKey: "Access_Token") ?? ""

            request.setValue(connString, forHTTPHeaderField: "x-conn")
            request.setValue("bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print("Error: No data received")
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let dashboardModel = try decoder.decode(MasterDetailModel.self, from: data)
                    let dataToSave = try JSONEncoder().encode(dashboardModel.rows)

                    UserDefaults.standard.set(dataToSave, forKey: "parsedDataKey")
                    completion(dashboardModel.rows.compactMap { $0 })
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion([])
                }
            }
            task.resume()
        } catch {
            print("Error converting parameters to JSON data: \(error)")
        }
    }
}

//import Foundation
//import UIKit
//import CoreData
//
//class APIManager {
//    static func updateDataWithTimer() {
//        // Check if the last API call time is stored in UserDefaults
//        if let lastApiCallTime = UserDefaults.standard.object(forKey: "lastApiCallTime") as? Date {
//            // Calculate the time difference between now and the last API call time
//            let currentTime = Date()
//            let timeInterval = currentTime.timeIntervalSince(lastApiCallTime)
//
//            // If the time difference is greater than or equal to 30 minutes (1800 seconds)
//            if timeInterval >= 60 {
//                // Make the API call and update UserDefaults
//                makePOSTRequest { _ in
//                    UserDefaults.standard.set(currentTime, forKey: "lastApiCallTime")
//                }
//            }
//        } else {
//            // If no last API call time is stored, make the API call and update UserDefaults
//            makePOSTRequest { _ in
//                UserDefaults.standard.set(Date(), forKey: "lastApiCallTime")
//            }
//        }
//    }
//    static func makePOSTRequest(completion: @escaping ([[MasterDetailRow]]) -> Void) {
////         Define the API endpoint URL
////        let dataAlreadySaved = UserDefaults.standard.bool(forKey: "dataSavedKey")
////                if dataAlreadySaved {
////                    print("Data already saved, no need to save again in Core Data")
////                    completion([])
////                   return
////                }
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
//                "DistributorID": "1"
//            ]
//        ]
//
//        // Convert parameters to JSON data
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
//
//            // Create a URL request
//            var request = URLRequest(url: apiUrl)
//            request.httpMethod = "POST"
//            let connString = UserDefaults.standard.string(forKey: "connectString")
//            let accessToken = UserDefaults.standard.string(forKey: "Access_Token") ?? ""
//            request.setValue(connString, forHTTPHeaderField: "x-conn")
//            request.setValue("bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.httpBody = jsonData
//
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                guard let data = data else {
//                    print("Error: No data received")
//                    return
//                }
//                do {
//                    let decoder = JSONDecoder()
//                    let dashboardModel = try decoder.decode(MasterDetailModel.self, from: data)
////                    let flattenedRows = dashboardModel.rows.flatMap { $0 }
////
////                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
////                        let context = appDelegate.persistentContainer.viewContext
////                        // Flatten the array of arrays
////                        removeOldData(from: context)
////                        saveResponseToCoreData(flattenedRows, in: context)
////                     UserDefaults.standard.set(true, forKey: "dataSavedKey")
////                    }
//                    if let dataToSave = try? JSONEncoder().encode(dashboardModel.rows) {
//                                        UserDefaults.standard.set(dataToSave, forKey: "parsedDataKey")
//                                    }
//                    completion(dashboardModel.rows.compactMap { $0 }) // Call the completion handler with a flattened array
//                } catch {
//                    // Handle decoding errors
//                    print("Error decoding JSON: \(error)")
//                    completion([]) // Call the completion handler with an empty array or an appropriate error indicator
//                }
//            }
//            task.resume()
//        } catch {
//            print("Error converting parameters to JSON data: \(error)")
//        }
//    }
//    private static func removeOldData(from context: NSManagedObjectContext) {
//            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MasterDetailEntity.fetchRequest()
//            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//            do {
//                try context.execute(batchDeleteRequest)
//            } catch {
//                print("Error removing old data: \(error)")
//            }
//        }
//    private static func saveResponseToCoreData(_ rows: [MasterDetailRow], in context: NSManagedObjectContext) {
//        for row in rows {
//            let managedObject = MasterDetailEntity(context: context)
////            managedObject.distributorID = Int32(row.distributorID ?? 0)
////                       managedObject.customerID = Int32(row.customerID ?? 0)
////                       managedObject.customerCode = row.customerCode ?? ""
////                       managedObject.customerName = row.customerName ?? ""
////                       managedObject.address = row.address ?? ""
////                       managedObject.primaryContact = row.primaryContact ?? ""
////                       managedObject.emailAddress = row.emailAddress ?? ""
////                       managedObject.gender = row.gender ?? ""
////                       managedObject.customerImage = row.customerImage ?? ""
////                       managedObject.cnic = row.cnic ?? ""
////                       managedObject.otherContactNo = row.otherContactNo ?? ""
////                       managedObject.cardID = row.cardID ?? ""
////                       managedObject.nature = row.nature ?? ""
////                       managedObject.points = Int32(row.points ?? 0)
////                       managedObject.professionID = Int32(row.professionID ?? 0)
//                       managedObject.tableID = Int32(row.tableID ?? 0)
//if let tableNo = row.tableNo {
//            managedObject.tableNo = tableNo
//        }
//                       managedObject.bookingFrom = nil
//                       managedObject.bookingTo = nil
//                       managedObject.floorID = Int32(row.floorID ?? 0)
////                       managedObject.floorName = row.floorName?.rawValue ?? ""
//                       managedObject.orderTakeID = Int32(row.orderTakeID ?? 0)
//                       managedObject.orderTakeName = row.orderTakeName ?? ""
//                       managedObject.userTypeID = Int32(row.userTypeID ?? 0)
//                       managedObject.dmid = Int32(row.dmid ?? 0)
//                       managedObject.dmName = row.dmName ?? ""
//                       managedObject.dcid = Int32(row.dcid ?? 0)
//                       managedObject.dcName = row.dcName ?? ""
//                       managedObject.cashImpact = row.cashImpact ?? false
//                       managedObject.categoryID = Int32(row.categoryID ?? 0)
//                       managedObject.category = row.category ?? ""
//                       managedObject.parentCategoryID = Int32(row.parentCategoryID ?? 0)
//                       managedObject.imagePath = row.imagePath ?? ""
//                       managedObject.productCount = Int32(row.productCount ?? 0)
//                       managedObject.itemID = Int32(row.itemID ?? 0)
//                       managedObject.itemCode = row.itemCode ?? ""
////                       managedObject.itemName = row.itemName ?? ""
//            if let itemName = row.itemName {
//                        managedObject.itemName = itemName
//                    }
////                       managedObject.rating = Int32(row.rating ?? 0)
////                      managedObject.favourite = Int32(row.favourite ?? 0)
//                      managedObject.price = Int32(row.price ?? 0)
////                       managedObject.discountPer = Int32(row.discountPer ?? 0)
////                       managedObject.discountPrice = Int32(row.discountPrice ?? 0)
////                       managedObject.isAddsOn = Int32(row.isAddsOn ?? 0)
////                       managedObject.isHasAddsOn = Int32(row.isHasAddsOn ?? 0)
////                       managedObject.isDeal = row.isDeal ?? false
////                       managedObject.isUnGroup = row.isUnGroup ?? false
//                      managedObject.sectionID = Int32(row.sectionID ?? 0)
//                       managedObject.sectionName = row.sectionName?.rawValue ?? ""
////                       managedObject.adsOnID = Int32(row.adsOnID ?? 0)
////                       managedObject.adsOnName = row.adsOnName ?? ""
////                       managedObject.adsOnCategoryID = Int32(row.adsOnCategoryID ?? 0)
////                       managedObject.adsOnCategoryName = row.adsOnCategoryName?.rawValue ?? ""
////                       managedObject.categoryName = row.categoryName ?? ""
////                       managedObject.dealID = Int32(row.dealID ?? 0)
//            if let dealName = row.dealName {
//                if !dealName.isEmpty{
//                    managedObject.dealName = dealName
//                    print(managedObject.dealName!)
//                }
//                    }
////                       managedObject.dealItemQuantity = Int32(row.dealItemQuantity ?? 0)
//            if let dealPrice = row.dealPrice {
//                managedObject.dealPrice = Int32(dealPrice)
//                    }
//
////                       managedObject.dealPrice = Int32(row.dealPrice ?? 0)
////                       managedObject.intDealID = Int32(row.intDealID ?? 0)
////                       managedObject.dealItems = row.dealItems ?? ""
////                       managedObject.id = Int32(row.id ?? 0)
////                       managedObject.serviceType = row.serviceType ?? ""
////                       managedObject.imageName = row.imageName ?? ""
////                       managedObject.orderCount = Int32(row.orderCount ?? 0)
////                       managedObject.occupationID = Int32(row.occupationID ?? 0)
////                       managedObject.occupationName = row.occupationName ?? ""
////                       managedObject.lessCancelReasonID = Int32(row.lessCancelReasonID ?? 0)
////                       managedObject.lessCancelReason = row.lessCancelReason ?? ""
////                       managedObject.typeID = Int32(row.typeID ?? 0)
////                       managedObject.userID = Int32(row.userID ?? 0)
////                       managedObject.userLogin = row.userLogin ?? ""
////                       managedObject.userPasswrd = row.userPasswrd ?? ""
////                       managedObject.isLessRight = row.isLessRight ?? false
////                       managedObject.isDelRight = row.isDelRight ?? false
////                       managedObject.canComplimentaryItem = row.canComplimentaryItem ?? false
////                       managedObject.canGiveDiscount = row.canGiveDiscount ?? false
////                       managedObject.gstPer = Int32(row.gstPer ?? 0)
////                       managedObject.creditCardGSTPer = Int32(row.creditCardGSTPer ?? 0)
////                       managedObject.locationAddress = row.locationAddress ?? ""
////                       managedObject.ntn = row.ntn ?? ""
////                       managedObject.logo = row.logo ?? ""
////                       managedObject.phoneNo = row.phoneNo ?? ""
////                       managedObject.serverURL = row.serverURL ?? ""
////                       managedObject.isPrintKOT = row.isPrintKOT ?? false
////                       managedObject.isServiceCharges = row.isServiceCharges ?? false
////                       managedObject.serviceChargesType = Int32(row.serviceChargesType ?? 0)
////                       managedObject.serviceChargesValue = Int32(row.serviceChargesValue ?? 0)
////                       managedObject.taxAuthorityName = row.taxAuthorityName ?? ""
////                       managedObject.ntnLabelText = row.ntnLabelText ?? ""
////                       managedObject.gstCalculation = row.gstCalculation ?? ""
////                       managedObject.isKOTMandatory = row.isKOTMandatory ?? ""
////                       managedObject.isKOTUniquePerDay = row.isKOTUniquePerDay ?? ""
////                       managedObject.printCustomerOnDelivery = row.printCustomerOnDelivery ?? ""
////                       managedObject.showNTNOnProvissionalBill = row.showNTNOnProvissionalBill ?? ""
////                       managedObject.billFormat = row.billFormat ?? ""
////                       managedObject.taxAuthority = row.taxAuthority ?? ""
////                       managedObject.provisionalBillHeaderFormat = row.provisionalBillHeaderFormat ?? ""
////                       managedObject.isFullKOT = row.isFullKOT ?? ""
////                       managedObject.hideOrderInvoieNo = row.hideOrderInvoieNo ?? ""
////                       managedObject.itemWiseDiscount = row.itemWiseDiscount ?? ""
////                       managedObject.isPriceOpenOnPOS = row.isPriceOpenOnPOS ?? ""
////                       managedObject.customerEngagement = row.customerEngagement ?? ""
////                       managedObject.customerInfoOnBill = row.customerInfoOnBill ?? ""
////                       managedObject.autoPromotion = row.autoPromotion ?? ""
////                       managedObject.locationNameOnKOT = row.locationNameOnKOT ?? ""
////                       managedObject.discountAuthentication = row.discountAuthentication ?? ""
////                       managedObject.discountTypeID = Int32(row.discountTypeID ?? 0)
////                       managedObject.discountTypeName = row.discountTypeName ?? ""
////                       managedObject.invocieCommentID = Int32(row.invocieCommentID ?? 0)
////                       managedObject.invoiceComment = row.invoiceComment ?? ""
////                       managedObject.bankDiscountID = Int32(row.bankDiscountID ?? 0)
////                       managedObject.discountName = row.discountName ?? ""
////                       managedObject.limit = Int32(row.limit ?? 0)
////                       managedObject.cardNo = row.cardNo ?? ""
//
//        }
//
//        do {
//            try context.save()
//        } catch {
//            print("Error saving Core Data context: \(error)")
//        }
//    }
//}
//class CoreDataHelper {
//    static func retrieveData() -> [MasterDetailEntity] {
//        var results: [MasterDetailEntity] = []
//
//        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//            let context = appDelegate.persistentContainer.viewContext
//
//            let fetchRequest: NSFetchRequest<MasterDetailEntity> = MasterDetailEntity.fetchRequest()
//
//            do {
//                results = try context.fetch(fetchRequest)
//            } catch {
//                print("Error fetching data from Core Data: \(error)")
//            }
//        }
//
//        return results
//    }
//}
//

