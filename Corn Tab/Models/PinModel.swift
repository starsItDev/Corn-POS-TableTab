//
//  PinModel.swift
//  Corn Tab
//
//  Created by StarsDev on 20/07/2023.
//

import Foundation

// MARK: - Welcome
struct Welcome {
    let clientID: Int
    let clientConnString: String
    let imagePath1, imagePath2: NSNull
    let imageServerURL: String
    let status: Bool
}
//        UserDefaults.standard.set("123", forKey: "ok")
//        let qwerty = UserDefaults.standard.string(forKey: "ok")
//        UserInfo.shared.accessToken = ""
//        let qwer = UserInfo.shared.accessToken
//        let urlString = "https://jhh3bgjqhj.execute-api.ap-southeast-1.amazonaws.com/Prod/MultiTenant/GetClientInfo?Pin=\(pin)"


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let dashBoardModel = try? JSONDecoder().decode(DashBoardModel.self, from: jsonData)

//import Foundation
//
//struct Model: Codable {
//    let code: Int
//    let body: Body
//}
//
//struct Body: Codable {
//    let current, pending, rejected, followed: [Current]
//    let past, extra: [Current]
//}
//
//struct Current: Codable {
//    let activity, activityID, categoryID, ownerID: String
//    let date, location: String
//    let catAvatar: String
//    let status: String?
//    let distance: Int
//    let ownerTitle: OwnerTitle
//    let time: String
//    let avatar: String
//
//    enum CodingKeys: String, CodingKey {
//        case activity
//        case activityID = "activity_id"
//        case categoryID = "category_id"
//        case ownerID = "owner_id"
//        case date, location
//        case catAvatar = "cat_avatar"
//        case status, distance
//        case ownerTitle = "owner_title"
//        case time, avatar
//    }
//}
//
//enum OwnerTitle: String, Codable {
//    case ahmad = "AHMAD"
//}
