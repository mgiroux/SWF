//
//  SWFRouter.swift
//  Swift Web Framework
//
//  Created by Marc Giroux on 2018-05-19.
//

import Foundation
import PerfectHTTP
import PerfectHTTPServer

public enum SWFWebMethod {
    case get
    case post
    case delete
    case put
    case options
    case head
    case patch
}

open class SWFRouter
{
    internal var routes = Routes()
    internal var groups = [String: Routes]()
    
    init()
    {
        // This handles static files
        self.routes.add(method: .get, uri: "/public/**") { (request, response) in
            request.path = "public/" + request.urlVariables[routeTrailingWildcardKey]!
            let handler = StaticFileHandler(documentRoot: Bundle.main.bundlePath + "/public", allowResponseFilters: true)
            handler.handleRequest(request: request, response: response)
        }
    }
    
    public func addRoute(method: SWFWebMethod, uri: String, handler: @escaping (SWFServerRequest, SWFServerResponse) -> ())
    {
        let httpMethod = self.getPerfectMethodType(method)
        
        self.routes.add(method: httpMethod, uri: uri, handler: { (request, response) in
            handler(request as SWFServerRequest, response as SWFServerResponse)
        })
    }
    
    public func addRoute(group: String, method: SWFWebMethod, uri: String, handler: @escaping (SWFServerRequest, SWFServerResponse) -> ())
    {
        let httpMethod = self.getPerfectMethodType(method)
        
        self.groups[group]?.add(method: httpMethod, uri: uri, handler: { (request, response) in
            handler(request as SWFServerRequest, response as SWFServerResponse)
        })
    }
    
    public func addRouteGroup(name: String, path: String)
    {
        let group         = Routes(baseUri: path)
        self.groups[name] = group
    }
        
    // ------------------------------------ Private methods ------------------------------------ //
    
    private func getPerfectMethodType(_ method: SWFWebMethod) -> HTTPMethod
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
