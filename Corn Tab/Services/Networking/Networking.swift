//
//  Networking.swift
//  Corn Tab
//
//  Created by StarsDev on 20/07/2023.

//
//  Networking.swift
//  Corn Tab
//
//  Created by StarsDev on 20/07/2023.

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

class Networking {
    
    // MARK: - Singleton
    
    static let instance = Networking()
    
    // MARK: - Get API Call
    
    func getApiCall(url: String, completionHandler: @escaping (_ Response: JSON, _ Error: String?, _ StatusCode: Int) -> ()) {
        let token = UserInfo.shared.accessToken
        var header: HTTPHeaders = [:]
        
        if !token.isEmpty {
            header = [
                "Authorization": "Bearer \(token)",
                "Accept": "application/json"
            ]
        } else {
            header = [
                "Authorization": "nil",
                "Accept": "application/json"
            ]
        }
        
        print(header)
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).response { (response) in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")// response serialization result
            
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .success(_):
                guard let data = response.data else { return }
                completionHandler(JSON(data), nil, statusCode ?? -1)
                
            case .failure(let error):
                completionHandler(JSON(error), error.localizedDescription, statusCode ?? -1)
            }
        }
    }
    
    // MARK: - Post API Call
    
    func postApiCall(url: String, param: [String: Any], completionHandler: @escaping (_ Response: JSON, _ Error: String?, _ StatusCode: Int) -> ()) {
        let token = UserInfo.shared.accessToken
        var header: HTTPHeaders = [:]
        
        if !token.isEmpty {
            header = [
                "Authorization": "\(UserInfo.shared.tokenType) \(token)",
                "Accept": "application/json"
            ]
        } else {
            header = [
                "Authorization": "nil",
                "Accept": "application/json"
            ]
        }
        
        print(header)
        
        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).response { (response) in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")// response serialization result
            
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .success(_):
                guard let data = response.data else { return }
                completionHandler(JSON(data), nil, statusCode ?? -1)
                
            case .failure(let error):
                completionHandler(JSON(error), error.localizedDescription, statusCode ?? -1)
            }
        }
    }
    
    // MARK: - Delete API Call
    
    func deleteApiCall(url: String, completionHandler: @escaping (_ Response: JSON, _ Error: String?, _ StatusCode: Int) -> ()) {
        let token = UserInfo.shared.accessToken
        var header: HTTPHeaders = [:]
        
        if !token.isEmpty {
            header = [
                "Authorization": "JWT \(token)",
                "Accept": "application/json"
            ]
        } else {
            header = [
                "Authorization": "nil",
                "Accept": "application/json"
            ]
        }
        
        AF.request(url, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: header).response { (response) in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")// response serialization result
            
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .success(_):
                guard let data = response.data else { return }
                completionHandler(JSON(data), nil, statusCode ?? -1)
                
            case .failure(let error):
                completionHandler(JSON(error), error.localizedDescription, statusCode ?? -1)
            }
        }
    }
    
    // MARK: - Put API Call
    
    func putApiCall(url: String, param: [String: Any], completionHandler: @escaping (_ Response: JSON, _ Error: String?, _ StatusCode: Int) -> ()) {
        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).response { (response) in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")// response serialization result
            
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .success(_):
                guard let data = response.data else { return }
                completionHandler(JSON(data), nil, statusCode ?? -1)
                
            case .failure(let error):
                completionHandler(JSON(error), error.localizedDescription, statusCode ?? -1)
            }
        }
    }
}
//Networking.instance.getApiCall(url: ""){(response, error, statusCode) in
//
//}
