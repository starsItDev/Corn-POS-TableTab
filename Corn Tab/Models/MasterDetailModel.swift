// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct MasterDetailModel: Codable {
    let rows: [[MasterDetailRow]]
    let totalLength: Int
    let status: Bool

    enum CodingKeys: String, CodingKey {
        case rows = "Rows"
        case totalLength = "TotalLength"
        case status = "Status"
    }
}

// MARK: - Row
struct MasterDetailRow: Codable {
    let distributorID, customerID: Int?
    let customerCode: String?
    let customerName: String?
    let address, primaryContact: String?
    let emailAddress: String?
    let gender: Gender?
    let customerImage: String?
    let cnic, otherContactNo, cardID, nature: String?
    let points, professionID: Int?
    let tableID: Int?
    let tableNo: String?
    let bookingFrom, bookingTo: JSONNull?
    let floorID: Int?
    let floorName: FloorName?
    let orderTakeID: Int?
    let orderTakeName: String?
    let userTypeID, dmid: Int?
    let dmName: String?
    let dcid: Int?
    let dcName: String?
    let cashImpact: Bool?
    let categoryID: Int?
    let category: String?
    let parentCategoryID: Int?
    let imagePath: String?
    let productCount: Int?
    let cssClass: String?
    let sortOrder: Int?
    let isMultiSelectModifier: Bool?
    let itemID: Int?
    let itemCode, itemName: String?
    let rating, favourite: Int?
    let price: Double?
    let discountPer, discountPrice, isAddsOn, isHasAddsOn: Int?
    let isDeal, isUnGroup: Bool?
    let sectionID: Int?
    let sectionName: SectionName?
    let adsOnID: Int?
    let adsOnName: String?
    let adsOnCategoryID: Int?
    let adsOnCategoryName: AdsOnCategoryName?
    let categoryName: String?
    let dealID: Int?
    let dealName: String?
    let dealItemQuantity, dealPrice, intDealID: Int?
    let dealItems: String?
    let id: Int?
    let serviceType, imageName: String?
    let orderCount, occupationID: Int?
    let occupationName: String?
    let lessCancelReasonID: Int?
    let lessCancelReason: String?
    let typeID, userID: Int?
    let userLogin, userPasswrd: String?
    let isLessRight, isDelRight, canComplimentaryItem, canGiveDiscount: Bool?
    let gstPer, creditCardGSTPer: Int?
    let locationAddress, ntn: String?
    let logo: String?
    let phoneNo: String?
    let serverURL: String?
    let isPrintKOT, isServiceCharges: Bool?
    let serviceChargesType, serviceChargesValue: Int?
    let taxAuthorityName, ntnLabelText, autoPromotion, billFormat: String?
    let customerAdvance, customerWiseGST, discountAuthentication, eatIn: String?
    let gstCalculation, hiddenReports, hideBillNo, hideOrderInvoieNo: String?
    let invoiceFormat, isFullKOT, isKOTMandatory, isKOTUniquePerDay: String?
    let isPriceOpenOnPOS, itemWiseDiscount, itemWiseGST, locationNameOnKOT: String?
    let printCustomerOnDelivery, provisionalBillHeaderFormat, serviceChargesCalculation, serviceChargesOnTakeaway: String?
    let showModifirPriceOnBills, showNTNOnProvissionalBill, showParentCategory, takeawayTokenIDMandatory: String?
    let taxAuthority, validateStockOnPOS: String?
    let discountTypeID: Int?
    let discountTypeName: String?
    let invocieCommentID: Int?
    let invoiceComment: String?
    let bankDiscountID: Int?
    let discountName: String?
    let limit: Int?
    let cardNo: String?
    let reportID: Int?
    let reportName: String?

    enum CodingKeys: String, CodingKey {
        case distributorID = "DistributorID"
        case customerID = "CustomerID"
        case customerCode = "CustomerCode"
        case customerName = "CustomerName"
        case address = "Address"
        case primaryContact = "PrimaryContact"
        case emailAddress = "EmailAddress"
        case gender = "Gender"
        case customerImage = "CustomerImage"
        case cnic = "CNIC"
        case otherContactNo = "OtherContactNo"
        case cardID = "CardID"
        case nature = "Nature"
        case points = "Points"
        case professionID = "ProfessionID"
        case tableID = "TableID"
        case tableNo = "TableNo"
        case bookingFrom = "BookingFrom"
        case bookingTo = "BookingTo"
        case floorID = "FloorID"
        case floorName = "FloorName"
        case orderTakeID = "OrderTakeID"
        case orderTakeName = "OrderTakeName"
        case userTypeID = "USER_TYPE_ID"
        case dmid = "DMID"
        case dmName = "DMName"
        case dcid = "DCID"
        case dcName = "DCName"
        case cashImpact = "CashImpact"
        case categoryID = "CategoryID"
        case category = "Category"
        case parentCategoryID = "ParentCategoryID"
        case imagePath = "ImagePath"
        case productCount = "ProductCount"
        case cssClass = "CSS_CLASS"
        case sortOrder = "SortOrder"
        case isMultiSelectModifier = "IsMultiSelectModifier"
        case itemID = "ItemID"
        case itemCode = "ItemCode"
        case itemName = "ItemName"
        case rating = "Rating"
        case favourite = "Favourite"
        case price = "Price"
        case discountPer = "DiscountPer"
        case discountPrice = "DiscountPrice"
        case isAddsOn = "IsAddsOn"
        case isHasAddsOn = "IsHasAddsOn"
        case isDeal = "IsDeal"
        case isUnGroup = "IsUnGroup"
        case sectionID = "SectionID"
        case sectionName = "SectionName"
        case adsOnID = "AdsOnID"
        case adsOnName = "AdsOnName"
        case adsOnCategoryID = "AdsOnCategoryID"
        case adsOnCategoryName = "AdsOnCategoryName"
        case categoryName = "CategoryName"
        case dealID = "DealID"
        case dealName = "DealName"
        case dealItemQuantity = "DealItemQuantity"
        case dealPrice = "DealPrice"
        case intDealID
        case dealItems = "DealItems"
        case id = "ID"
        case serviceType = "ServiceType"
        case imageName = "ImageName"
        case orderCount = "OrderCount"
        case occupationID = "OccupationID"
        case occupationName = "OccupationName"
        case lessCancelReasonID = "LessCancelReasonID"
        case lessCancelReason = "LessCancelReason"
        case typeID = "TypeID"
        case userID = "UserID"
        case userLogin = "UserLogin"
        case userPasswrd = "UserPasswrd"
        case isLessRight = "IsLessRight"
        case isDelRight = "IsDelRight"
        case canComplimentaryItem = "CanComplimentaryItem"
        case canGiveDiscount = "CanGiveDiscount"
        case gstPer = "GSTPer"
        case creditCardGSTPer = "CreditCardGSTPer"
        case locationAddress = "LocationAddress"
        case ntn = "NTN"
        case logo = "Logo"
        case phoneNo = "PhoneNo"
        case serverURL = "ServerUrl"
        case isPrintKOT = "IsPrintKOT"
        case isServiceCharges = "IsServiceCharges"
        case serviceChargesType = "ServiceChargesType"
        case serviceChargesValue = "ServiceChargesValue"
        case taxAuthorityName = "TaxAuthorityName"
        case ntnLabelText = "NTNLabelText"
        case autoPromotion = "AutoPromotion"
        case billFormat = "BillFormat"
        case customerAdvance = "CustomerAdvance"
        case customerWiseGST = "CustomerWiseGST"
        case discountAuthentication = "DiscountAuthentication"
        case eatIn = "EatIn"
        case gstCalculation = "GSTCalculation"
        case hiddenReports = "HiddenReports"
        case hideBillNo = "HideBillNo"
        case hideOrderInvoieNo = "HideOrderInvoieNo"
        case invoiceFormat = "InvoiceFormat"
        case isFullKOT = "IsFullKOT"
        case isKOTMandatory = "IsKOTMandatory"
        case isKOTUniquePerDay = "IsKOTUniquePerDay"
        case isPriceOpenOnPOS = "IsPriceOpenOnPOS"
        case itemWiseDiscount = "ItemWiseDiscount"
        case itemWiseGST = "ItemWiseGST"
        case locationNameOnKOT = "LocationNameOnKOT"
        case printCustomerOnDelivery = "PrintCustomerOnDelivery"
        case provisionalBillHeaderFormat = "ProvisionalBillHeaderFormat"
        case serviceChargesCalculation = "ServiceChargesCalculation"
        case serviceChargesOnTakeaway = "ServiceChargesOnTakeaway"
        case showModifirPriceOnBills = "ShowModifirPriceOnBills"
        case showNTNOnProvissionalBill = "ShowNTNOnProvissionalBill"
        case showParentCategory = "ShowParentCategory"
        case takeawayTokenIDMandatory = "TakeawayTokenIDMandatory"
        case taxAuthority = "TaxAuthority"
        case validateStockOnPOS = "ValidateStockOnPOS"
        case discountTypeID = "DiscountTypeID"
        case discountTypeName = "DiscountTypeName"
        case invocieCommentID = "InvocieCommentID"
        case invoiceComment = "InvoiceComment"
        case bankDiscountID = "BankDiscountID"
        case discountName = "DiscountName"
        case limit = "Limit"
        case cardNo = "CardNo"
        case reportID = "ReportID"
        case reportName = "ReportName"
    }
}

enum AdsOnCategoryName: String, Codable {
    case addOns = "Add Ons"
    case crustOption = "Crust Option"
    case dips = "Dips"
    case extraCheese = "Extra Cheese"
    case extraMeat = "Extra Meat"
    case size = "Size"
    case toppings = "Toppings"
}

enum FloorName: String, Codable {
    case basment = "Basment"
    case firstFloor = "First Floor"
    case secondFloor = "Second Floor"
}

enum Gender: String, Codable {
    case empty = ""
    case female = "Female"
    case male = "Male"
}

enum SectionName: String, Codable {
    case bar = "Bar"
    case kitchen = "Kitchen"
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}



//import Foundation

//// MARK: - DashBoardModel
//struct MasterDetailModel: Codable {
//    let rows: [[MasterDetailRow]]
//    let totalLength: Int
//    let status: Bool
//
//    enum CodingKeys: String, CodingKey {
//        case rows = "Rows"
//        case totalLength = "TotalLength"
//        case status = "Status"
//    }
//}

//// MARK: - Row
//struct MasterDetailRow: Codable {
//    let distributorID, customerID: Int?
//    let customerCode: String?
//    let customerName: String?
//    let address, primaryContact: String?
//    let emailAddress: String?
//    let gender: Gender?
//    let customerImage: String?
//    let cnic, otherContactNo, cardID, nature: String?
//    let points, professionID: Int?
//    let tableID: Int?
//    let tableNo: String?
//    let bookingFrom, bookingTo: JSONNullA?
//    let floorID: Int?
//    let floorName: FloorName?
//    let orderTakeID: Int?
//    let orderTakeName: String?
//    let userTypeID, dmid: Int?
//    let dmName: String?
//    let dcid: Int?
//    let dcName: String?
//    let cashImpact: Bool?
//    let categoryID: Int?
//    let category: String?
//    let parentCategoryID: Int?
//    let imagePath: String?
//    let productCount: Int?
//    let cssClass: String?
//    let sortOrder: Int?
//    let isMultiSelectModifier: Bool?
//    let itemID: Int?
//    let itemCode, itemName: String?
//    let rating, favourite, price, discountPer: Int?
//    let discountPrice, isAddsOn, isHasAddsOn: Int?
//    let isDeal, isUnGroup: Bool?
//    let sectionID: Int?
//    let sectionName: SectionName?
//    let adsOnID: Int?
//    let adsOnName: String?
//    let adsOnCategoryID: Int?
//    let adsOnCategoryName: AdsOnCategoryName?
//    let categoryName: String?
//    let dealID: Int?
//    let dealName: String?
//    let dealItemQuantity, dealPrice, intDealID: Int?
//    let dealItems: String?
//    let id: Int?
//    let serviceType, imageName: String?
//    let orderCount, occupationID: Int?
//    let occupationName: String?
//    let lessCancelReasonID: Int?
//    let lessCancelReason: String?
//    let typeID, userID: Int?
//    let userLogin, userPasswrd: String?
//    let isLessRight, isDelRight, canComplimentaryItem, canGiveDiscount: Bool?
//    let gstPer, creditCardGSTPer: Int?
//    let locationAddress, ntn: String?
//    let logo: String?
//    let phoneNo: String?
//    let serverURL: String?
//    let isPrintKOT, isServiceCharges: Bool?
//    let serviceChargesType, serviceChargesValue: Int?
//    let taxAuthorityName, ntnLabelText, autoPromotion, billFormat: String?
//    let customerAdvance, customerWiseGST, discountAuthentication, eatIn: String?
//    let gstCalculation, hiddenReports, hideBillNo, hideOrderInvoieNo: String?
//    let invoiceFormat, isFullKOT, isKOTMandatory, isKOTUniquePerDay: String?
//    let isPriceOpenOnPOS, itemWiseDiscount, itemWiseGST, locationNameOnKOT: String?
//    let printCustomerOnDelivery, provisionalBillHeaderFormat, serviceChargesCalculation, serviceChargesOnTakeaway: String?
//    let showModifirPriceOnBills, showNTNOnProvissionalBill, showParentCategory, takeawayTokenIDMandatory: String?
//    let taxAuthority, validateStockOnPOS: String?
//    let discountTypeID: Int?
//    let discountTypeName: String?
//    let invocieCommentID: Int?
//    let invoiceComment: String?
//    let bankDiscountID: Int?
//    let discountName: String?
//    let limit: Int?
//    let cardNo: String?
//
//    enum CodingKeys: String, CodingKey {
//        case distributorID = "DistributorID"
//        case customerID = "CustomerID"
//        case customerCode = "CustomerCode"
//        case customerName = "CustomerName"
//        case address = "Address"
//        case primaryContact = "PrimaryContact"
//        case emailAddress = "EmailAddress"
//        case gender = "Gender"
//        case customerImage = "CustomerImage"
//        case cnic = "CNIC"
//        case otherContactNo = "OtherContactNo"
//        case cardID = "CardID"
//        case nature = "Nature"
//        case points = "Points"
//        case professionID = "ProfessionID"
//        case tableID = "TableID"
//        case tableNo = "TableNo"
//        case bookingFrom = "BookingFrom"
//        case bookingTo = "BookingTo"
//        case floorID = "FloorID"
//        case floorName = "FloorName"
//        case orderTakeID = "OrderTakeID"
//        case orderTakeName = "OrderTakeName"
//        case userTypeID = "USER_TYPE_ID"
//        case dmid = "DMID"
//        case dmName = "DMName"
//        case dcid = "DCID"
//        case dcName = "DCName"
//        case cashImpact = "CashImpact"
//        case categoryID = "CategoryID"
//        case category = "Category"
//        case parentCategoryID = "ParentCategoryID"
//        case imagePath = "ImagePath"
//        case productCount = "ProductCount"
//        case cssClass = "CSS_CLASS"
//        case sortOrder = "SortOrder"
//        case isMultiSelectModifier = "IsMultiSelectModifier"
//        case itemID = "ItemID"
//        case itemCode = "ItemCode"
//        case itemName = "ItemName"
//        case rating = "Rating"
//        case favourite = "Favourite"
//        case price = "Price"
//        case discountPer = "DiscountPer"
//        case discountPrice = "DiscountPrice"
//        case isAddsOn = "IsAddsOn"
//        case isHasAddsOn = "IsHasAddsOn"
//        case isDeal = "IsDeal"
//        case isUnGroup = "IsUnGroup"
//        case sectionID = "SectionID"
//        case sectionName = "SectionName"
//        case adsOnID = "AdsOnID"
//        case adsOnName = "AdsOnName"
//        case adsOnCategoryID = "AdsOnCategoryID"
//        case adsOnCategoryName = "AdsOnCategoryName"
//        case categoryName = "CategoryName"
//        case dealID = "DealID"
//        case dealName = "DealName"
//        case dealItemQuantity = "DealItemQuantity"
//        case dealPrice = "DealPrice"
//        case intDealID
//        case dealItems = "DealItems"
//        case id = "ID"
//        case serviceType = "ServiceType"
//        case imageName = "ImageName"
//        case orderCount = "OrderCount"
//        case occupationID = "OccupationID"
//        case occupationName = "OccupationName"
//        case lessCancelReasonID = "LessCancelReasonID"
//        case lessCancelReason = "LessCancelReason"
//        case typeID = "TypeID"
//        case userID = "UserID"
//        case userLogin = "UserLogin"
//        case userPasswrd = "UserPasswrd"
//        case isLessRight = "IsLessRight"
//        case isDelRight = "IsDelRight"
//        case canComplimentaryItem = "CanComplimentaryItem"
//        case canGiveDiscount = "CanGiveDiscount"
//        case gstPer = "GSTPer"
//        case creditCardGSTPer = "CreditCardGSTPer"
//        case locationAddress = "LocationAddress"
//        case ntn = "NTN"
//        case logo = "Logo"
//        case phoneNo = "PhoneNo"
//        case serverURL = "ServerUrl"
//        case isPrintKOT = "IsPrintKOT"
//        case isServiceCharges = "IsServiceCharges"
//        case serviceChargesType = "ServiceChargesType"
//        case serviceChargesValue = "ServiceChargesValue"
//        case taxAuthorityName = "TaxAuthorityName"
//        case ntnLabelText = "NTNLabelText"
//        case autoPromotion = "AutoPromotion"
//        case billFormat = "BillFormat"
//        case customerAdvance = "CustomerAdvance"
//        case customerWiseGST = "CustomerWiseGST"
//        case discountAuthentication = "DiscountAuthentication"
//        case eatIn = "EatIn"
//        case gstCalculation = "GSTCalculation"
//        case hiddenReports = "HiddenReports"
//        case hideBillNo = "HideBillNo"
//        case hideOrderInvoieNo = "HideOrderInvoieNo"
//        case invoiceFormat = "InvoiceFormat"
//        case isFullKOT = "IsFullKOT"
//        case isKOTMandatory = "IsKOTMandatory"
//        case isKOTUniquePerDay = "IsKOTUniquePerDay"
//        case isPriceOpenOnPOS = "IsPriceOpenOnPOS"
//        case itemWiseDiscount = "ItemWiseDiscount"
//        case itemWiseGST = "ItemWiseGST"
//        case locationNameOnKOT = "LocationNameOnKOT"
//        case printCustomerOnDelivery = "PrintCustomerOnDelivery"
//        case provisionalBillHeaderFormat = "ProvisionalBillHeaderFormat"
//        case serviceChargesCalculation = "ServiceChargesCalculation"
//        case serviceChargesOnTakeaway = "ServiceChargesOnTakeaway"
//        case showModifirPriceOnBills = "ShowModifirPriceOnBills"
//        case showNTNOnProvissionalBill = "ShowNTNOnProvissionalBill"
//        case showParentCategory = "ShowParentCategory"
//        case takeawayTokenIDMandatory = "TakeawayTokenIDMandatory"
//        case taxAuthority = "TaxAuthority"
//        case validateStockOnPOS = "ValidateStockOnPOS"
//        case discountTypeID = "DiscountTypeID"
//        case discountTypeName = "DiscountTypeName"
//        case invocieCommentID = "InvocieCommentID"
//        case invoiceComment = "InvoiceComment"
//        case bankDiscountID = "BankDiscountID"
//        case discountName = "DiscountName"
//        case limit = "Limit"
//        case cardNo = "CardNo"
//    }
//}
//
//enum AdsOnCategoryName: String, Codable {
//    case addOns = "Add Ons"
//    case crustOption = "Crust Option"
//    case dips = "Dips"
//    case extraCheese = "Extra Cheese"
//    case extraMeat = "Extra Meat"
//    case size = "Size"
//    case toppings = "Toppings"
//}
//
//enum FloorName: String, Codable {
//    case basment = "Basment"
//    case firstFloor = "First Floor"
//    case secondFloor = "Second Floor"
//}
//
//enum Gender: String, Codable {
//    case empty = ""
//    case male = "Male"
//}
//
//enum SectionName: String, Codable {
//    case bar = "Bar"
//    case kitchen = "Kitchen"
//}
//
//// MARK: - Encode/decode helpers
//
//class JSONNullA: Codable, Hashable {
//
//    public static func == (lhs: JSONNullA, rhs: JSONNullA) -> Bool {
//        return true
//    }
//
//    public var hashValue: Int {
//        return 0
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if !container.decodeNil() {
//            throw DecodingError.typeMismatch(JSONNullA.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encodeNil()
//    }
//}
