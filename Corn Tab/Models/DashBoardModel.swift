

import Foundation

// MARK: - DashBoardModel
struct DashBoardModel: Codable {
    let rows: [Row]
    let totalLength: Int
    let status: Bool

    enum CodingKeys: String, CodingKey {
        case rows = "Rows"
        case totalLength = "TotalLength"
        case status = "Status"
    }
}

// MARK: - Row
//struct Row: Codable {
//    let orderID: Int
//    let orderNO: String
//    let invoiceNo, serviceTypeID, paymentMode: Int
//    let tableID: String?
//    let grossAmount: Double
//    let coverTable: String?
//    let customerID: Int?
//    let manualOrderNo: String
//    let remarks: String?
//    let gstAmount: Double?
//    let deliveryChannel, itemWiseDiscount, orderTakeID: Int?
//    let serviceCharges: Int
//    let serviceChargesType, discount: Int?
//    let discountType: Int
//    let bankID, paymentReceived, customerID1: Int?
//    let customerName: String?
//    let netAmount: Double?
//    let createDateTime: String
//    let covers: String?
//    let gstPer, bankDiscountID: Int?
//    let creditCardNo, creditCardAccountTile: String?
//    let empDiscountType: Int?
//    let orderDetail, tableDetail: String?
//
//    enum CodingKeys: String, CodingKey {
//        case orderID = "OrderID"
//        case orderNO = "OrderNO"
//        case invoiceNo = "InvoiceNo"
//        case serviceTypeID = "ServiceTypeID"
//        case paymentMode = "PaymentMode"
//        case tableID = "TableID"
//        case grossAmount = "GrossAmount"
//        case coverTable = "CoverTable"
//        case customerID = "CustomerID"
//        case manualOrderNo = "ManualOrderNo"
//        case remarks = "Remarks"
//        case gstAmount = "GSTAmount"
//        case deliveryChannel = "DeliveryChannel"
//        case itemWiseDiscount = "ItemWiseDiscount"
//        case orderTakeID = "OrderTakeId"
//        case serviceCharges = "ServiceCharges"
//        case serviceChargesType = "ServiceChargesType"
//        case discount = "Discount"
//        case discountType = "DiscountType"
//        case bankID = "BankID"
//        case paymentReceived = "PaymentReceived"
//        case customerID1 = "CustomerID1"
//        case customerName = "CustomerName"
//        case netAmount = "NetAmount"
//        case createDateTime = "CreateDateTime"
//        case covers = "Covers"
//        case gstPer = "GSTPer"
//        case bankDiscountID = "BankDiscountID"
//        case creditCardNo = "CreditCardNo"
//        case creditCardAccountTile = "CreditCardAccountTile"
//        case empDiscountType = "EmpDiscountType"
//        case orderDetail = "OrderDetail"
//        case tableDetail = "TableDetail"
//    }
//}

struct Row: Codable {
    let orderID: Double
    let orderNO: String
    let invoiceNo, serviceTypeID, paymentMode: Double
    let tableID: String?
    let grossAmount: Double
    let coverTable: String?
    let customerID: Double?
    let manualOrderNo: String
    let remarks: String?
    let gstAmount: Double?
    let deliveryChannel, itemWiseDiscount, orderTakeID: Double?
    let serviceCharges: Double
    let serviceChargesType, discount: Double?
    let discountType: Double
    let bankID, paymentReceived, customerID1: Double?
    let customerName: String?
    let netAmount: Double?
    let createDateTime, covers: String?
//    let createDateTime: String
//    let covers: String?
    let gstPer, bankDiscountID: Double?
    let creditCardNo, creditCardAccountTile: String?
    let empDiscountType: Double?
    let orderDetail, tableDetail: String?

    enum CodingKeys: String, CodingKey {
        case orderID = "OrderID"
        case orderNO = "OrderNO"
        case invoiceNo = "InvoiceNo"
        case serviceTypeID = "ServiceTypeID"
        case paymentMode = "PaymentMode"
        case tableID = "TableID"
        case grossAmount = "GrossAmount"
        case coverTable = "CoverTable"
        case customerID = "CustomerID"
        case manualOrderNo = "ManualOrderNo"
        case remarks = "Remarks"
        case gstAmount = "GSTAmount"
        case deliveryChannel = "DeliveryChannel"
        case itemWiseDiscount = "ItemWiseDiscount"
        case orderTakeID = "OrderTakeId"
        case serviceCharges = "ServiceCharges"
        case serviceChargesType = "ServiceChargesType"
        case discount = "Discount"
        case discountType = "DiscountType"
        case bankID = "BankID"
        case paymentReceived = "PaymentReceived"
        case customerID1 = "CustomerID1"
        case customerName = "CustomerName"
        case netAmount = "NetAmount"
        case createDateTime = "CreateDateTime"
        case covers = "Covers"
        case gstPer = "GSTPer"
        case bankDiscountID = "BankDiscountID"
        case creditCardNo = "CreditCardNo"
        case creditCardAccountTile = "CreditCardAccountTile"
        case empDiscountType = "EmpDiscountType"
        case orderDetail = "OrderDetail"
        case tableDetail = "TableDetail"
    }
}
