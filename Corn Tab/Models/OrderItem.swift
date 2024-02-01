//
//  OrderItem.swift
//  Corn Tab
//
//  Created by Apple on 23/11/2023.
//

import Foundation

struct OrderItem: Codable {
    var orderID: Int?
    var id: Int
    var name: String
    var price: Double?
    var amount: Double?
    var isVoid: Bool?
    var qty: Double?
    var discount: Double?
    var itemWiseGST: Double?
    var isAddsOn: Bool
    var isDeal: Int?
    var dealID: Int?
    var dealName: String
    var dealPrice: Double?
    var dealQty: Double?
    var isHasAddsOn: Bool
    var modifierParentID: Int
    var modifierParentRowID: Int?
    var invoiceDetailID: Int?
    var sectionID: Int?
    var sectionName: String?
    var orderNotes: String?

    enum CodingKeys: String, CodingKey {
        case orderID = "OrderID"
        case id = "ID"
        case name = "Name"
        case price = "Price"
        case amount = "Amount"
        case isVoid = "IsVoid"
        case qty = "Qty"
        case discount = "Discount"
        case itemWiseGST = "ItemWiseGST"
        case isAddsOn = "IsAddsOn"
        case isDeal = "IsDeal"
        case dealPrice = "DealPrice"
        case dealID = "DealID"
        case dealName = "DealName"
        case dealQty = "DealQty"
        case isHasAddsOn = "IsHasAddsOn"
        case modifierParentID = "ModifierParentID"
        case modifierParentRowID = "ModifierParentRowID"
        case invoiceDetailID = "InvoiceDetailID"
        case sectionID = "SectionID"
        case sectionName = "SectionName"
        case orderNotes = "OrderNotes"
    }
}


struct TableItem: Codable {
    var OrderID: Int?
    var TableID: Int?
    var TableName: String?
    
    
    enum CodingKeys: String, CodingKey {
    case OrderID = "OrderID"
    case TableID = "TableID"
    case TableName = "TableName"
    }
}
