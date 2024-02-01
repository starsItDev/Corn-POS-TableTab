//
//  UserInfo.swift
//  Corn Tab
//
//  Created by StarsDev on 20/07/2023.
//
import Foundation

//enum loggedInThrough{
//  case manually
//  case facebook
//  case google
//  case apple
//}
//Singleton pattern
final class UserInfo {

  static let shared = UserInfo()
  let defaults = UserDefaults.standard
  //var userName = ""
  var password = ""
    
  //var firstName = ""
  //var lastName = ""
  //var email = ""
  //var imageUrl : String?
  var isUserLoggedIn : Bool {
    get { return defaults.bool(forKey: .strKeyUserDefaultsisUserLogged)   }
    set { defaults.set(newValue, forKey: .strKeyUserDefaultsisUserLogged) }
  }
  var userId : Int {
      get { return defaults.integer(forKey: .strKeyUserDefaultsUserId)}
    set { defaults.set(newValue, forKey: .strKeyUserDefaultsUserId) }
  }
  var accessToken :String {
    get { return defaults.string(forKey: .strKeyUserDefaultsAccessTokenAuthentication) ?? ""}
    set { defaults.set(newValue, forKey: .strKeyUserDefaultsAccessTokenAuthentication)}
  }
    var refreshToken :String {
      get { return defaults.string(forKey: .strKeyUserDefaultsRefreshTokenAuthentication) ?? ""}
      set { defaults.set(newValue, forKey: .strKeyUserDefaultsRefreshTokenAuthentication)}
    }
    var expiresTime :Int {
      get { return defaults.integer(forKey: .strKeyUserDefaultsExpiresTime)}
      set { defaults.set(newValue, forKey: .strKeyUserDefaultsExpiresTime)}
    }
    var tokenType :String {
      get { return defaults.string(forKey: .strKeyUserDefaultsTokenType) ?? ""}
      set { defaults.set(newValue, forKey: .strKeyUserDefaultsTokenType)}
    }
    //  var loggedInThrough : Int {
//    get { return defaults.integer(forKey: .strKeyUserLoggindInThrough) }
//    set { defaults.set(newValue, forKey: .strKeyUserLoggindInThrough)}
//  }
//  var userName : String {
//    get { return defaults.string(forKey: .strKeyUserDefaultsUserName) ?? ""}
//    set { defaults.set(newValue, forKey: .strKeyUserDefaultsUserName)}
//  }
  var firstName : String {
    get { return defaults.string(forKey: .strKeyUserDefaultsFirstName) ?? ""}
    set { defaults.set(newValue, forKey: .strKeyUserDefaultsFirstName)}
  }
  var lastName : String {
    get { return defaults.string(forKey: .strKeyUserDefaultsLastName) ?? ""}
    set { defaults.set(newValue, forKey: .strKeyUserDefaultsLastName)}
  }
  var email : String {
    get { return defaults.string(forKey: .strKeyUserDefaultsEmail) ?? ""}
    set { defaults.set(newValue, forKey: .strKeyUserDefaultsEmail)}
  }
//  var imageUrl : String {
//    get { return defaults.string(forKey: .strKeyUserDefaultsImageUrl) ?? ""}
//    set { defaults.set(newValue, forKey: .strKeyUserDefaultsImageUrl)}
//  }
//  var latitude : String {
//      get { return defaults.string(forKey: .strKeyUserLatitude) ?? ""}
//      set { defaults.set(newValue, forKey: .strKeyUserLatitude)}
//  }
//
//  var longitude : String {
//      get { return defaults.string(forKey: .strKeyUserLongitude ) ?? ""}
//      set { defaults.set(newValue, forKey: .strKeyUserLongitude) }
//  }
//  var Country : String {
//      get { return defaults.string(forKey: .strKeyUserCountry ) ?? ""}
//      set { defaults.set(newValue, forKey: .strKeyUserCountry) }
//  }
//  var City : String {
//      get { return defaults.string(forKey: .strKeyUserCity ) ?? ""}
//      set { defaults.set(newValue, forKey: .strKeyUserCity) }
//  }
//  var State : String {
//      get { return defaults.string(forKey: .strKeyUserState ) ?? ""}
//      set { defaults.set(newValue, forKey: .strKeyUserState) }
//  }

//  private init() {
//
//  }

  public static func logOut() {
    self.shared.accessToken = ""
      self.shared.refreshToken = ""
    self.shared.isUserLoggedIn = false
    self.shared.userId = -1
      self.shared.firstName = ""
      self.shared.lastName = ""
      self.shared.expiresTime = -1
      self.shared.tokenType = ""
      self.shared.email = ""
    //self.shared.userName = ""
    //self.shared.loggedInThrough = -1
    

    //facebook logout
    //let loginManager = LoginManager()
    //loginManager.logOut()

    //google logout
    //GIDSignIn.sharedInstance().signOut()
  }
  public static func storeUserInfoArrayInInstance(array: [Any]) {
//    if let userName = array[0] as? String {
//      shared.userName = userName
//    }
      if let userID = array[0] as? Int {
        shared.userId = userID
      }
    if let fName = array[1] as? String {
      shared.firstName = fName
    }
    if let lName = array[2] as? String {
      shared.lastName = lName
    }
    if let email = array[3] as? String {
      shared.email = email
    }
    if let isLoggedIn = array[4] as? Bool {
      shared.isUserLoggedIn = isLoggedIn
    }
    
    if let accessToken = array[5] as? String {
      shared.accessToken = accessToken
      //UserDefaults.standard.set(authToken, forKey: .strKeyUserDefaultstokenOfAuthentication)
    }
      if let refreshToken = array[6] as? String {
        shared.refreshToken = refreshToken
        //UserDefaults.standard.set(authToken, forKey: .strKeyUserDefaultstokenOfAuthentication)
      }
      if let expiresTime = array[7] as? Int {
        shared.expiresTime = expiresTime
        //UserDefaults.standard.set(authToken, forKey: .strKeyUserDefaultstokenOfAuthentication)
      }
      if let tokenType = array[8] as? String {
        shared.tokenType = tokenType
        //UserDefaults.standard.set(authToken, forKey: .strKeyUserDefaultstokenOfAuthentication)
      }
//    if let photoUrl = array[7] as? String {
//      shared.imageUrl = photoUrl
//    }
//    if let loggedInThrough = array[8] as? Int {
//      shared.loggedInThrough = loggedInThrough
//      //UserDefaults.standard.set(loggedInThrough, forKey: .strKeyUserDefaultsLoggedFromFlag)
//    }

  }
}

extension String{
//    static let strKeyUserDefaultsUserName = "userName"
    static let strKeyUserDefaultsFirstName = "firstName"
    static let strKeyUserDefaultsLastName = "lastName"
    static let strKeyUserDefaultsPassword = "password"
    static let strKeyUserDefaultsEmail = "email"
//    static let strKeyUserDefaultsImageUrl = "imageUrl"
    static let strKeyUserDefaultsisUserLogged = "isUserLoggedIn"
    static let strKeyUserDefaultsUserId = "userId"
    static let strKeyUserLoggindInThrough = "loggedInThrough"
//    static let strKeyUserDefaultsLoggedFromFB = "loggedFromFacebook"
//    static let strKeyUserDefaultsLoggedFromGoogle = "loggedFromGoogle"
    static let strKeyUserDefaultsAccessTokenAuthentication = "accessTokenAuthentication"
    static let strKeyUserDefaultsRefreshTokenAuthentication = "refreshTokenAuthentication"
    static let strKeyUserDefaultsTokenType = "tokenType"
    static let strKeyUserDefaultsExpiresTime = "expiresTime"
    //static let strKeyUserDefaultsLoggedFromFlag = "loggedFromFlag"
//    static let strKeyUserLatitude = "userLatitude"
//    static let strKeyUserLongitude = "userLongitude"
//    static let strKeyUserCity = "userCity"
//    static let strKeyUserState = "userState"
//    static let strKeyUserCountry = "userCountry"
}
