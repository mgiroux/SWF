//
//  SWFWebRequest.swift
//  SwiftWebFramework
//
//  Created by Marc Giroux on 2018-05-27.
//

import Foundation
import SwiftyRequest

public typealias SWFWebRequestCallback = (Bool, [String: Any]?) -> ()

public struct SWFCredentials
{
    var username = ""
    var password = ""
}

public class SWFWebRequest
{
    public func jsonRequest(method: SWFWebMethod, url: String, headers: [String: String], data: [String: Any], hasJsonBody: Bool, credentials: SWFCredentials?, callback: @escaping SWFWebRequestCallback)
    {
        let _method = self.getMethodType(method)
        let request = RestRequest(method: _method, url: url)
        
        request.headerParameters = headers
        request.headerParameters["Accept"] = "application/json"
        
        if credentials != nil {
            request.credentials = .basicAuthentication(username: credentials!.username, password: credentials!.password)
        }
        
        if method == .post {
            let body = self.buildPostData(data)
            request.messageBody = body.data(using: .utf8)
            print(body)
        }
        
        request.responseData { (data) in
            if data.response!.statusCode < 300 {
                let json = self.parseJsonResponse(data: data.data!)
                callback(true, json)
            } else {
                callback(false, nil)
            }
        }
    }
    
    // MARK: - Private methods
    
    private func buildPostData(_ data: [String: Any]) -> String
    {
        var output = ""
        
        for (key, value) in data {
            if output != "" {
                output += "&"
            }
            
            if value is String {
                output += key + "="
                output += value as! String
            } else if value is Bool {
                let v = ((value as! Bool) == true) ? "true" : "false"
                output += key + "="
                output += v
            } else if value is Int {
                output += key + "="
                output += String(value as! Int)
            } else if value is Double {
                output += key + "="
                output += String(value as! Double)
            } else if value is Array<String> {
                let v = value as! [String]
                
                for el in v {
                    if output != "" {
                        output += "&"
                    }
                    
                    output += key + "[]="
                    output += el
                }
                
            } else if value is Dictionary<String, Any> {
                let dict = value as! [String: Any]
                let kval = self.buildPostData(dict)
                
                let parts = kval.components(separatedBy: "&")
                
                for part in parts {
                    let subparts = part.components(separatedBy: "=")
                    
                    if (output != "" ) {
                        output += "&"
                    }
                    
                    output += key + "[" + subparts[0] + "]=" + subparts[1]
                }
                
            }
        }
        
        return output
    }
    
    private func parseJsonResponse(data: Data) -> [String: Any]
    {
        do {
            let object = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            return object as! [String: Any]
        } catch {
            return [String: Any]()
        }
    }
    
    private func getMethodType(_ method: SWFWebMethod) -> HTTPMethod
    {
        var httpMethod = HTTPMethod.get
        
        switch method
        {
        case .get:
            httpMethod = .get
            break
            
        case .post:
            httpMethod = .post
            break
            
        case .delete:
            httpMethod = .delete
            break
            
        case .put:
            httpMethod = .put
            break
            
        case .options:
            httpMethod = .options
            break
            
        case .head:
            httpMethod = .head
            break
            
        case .patch:
            httpMethod = .patch
            break
        }
        
        return httpMethod
    }
}
